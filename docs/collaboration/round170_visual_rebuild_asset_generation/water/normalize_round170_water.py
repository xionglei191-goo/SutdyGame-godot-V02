from __future__ import annotations

import json
import shutil
from collections import deque
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw


ROOT = Path(__file__).resolve().parent
ASSET_DIR = Path("assets/art/visual_rebuild/round170/water")
RAW = ROOT / "raw" / "round170_water_pond_edge_ai_raw_sheet_v001.png"
ALPHA = ROOT / "normalized_64x64" / "round170_water_pond_edge_ai_raw_sheet_v001_chroma_alpha.png"
ATLAS = ROOT / "normalized_64x64" / "round170_water_pond_edge_ai_raw_sheet_v001_64x64_atlas.png"
PROOF = ROOT / "normalized_64x64" / "round170_water_pond_edge_ai_raw_sheet_v001_64x64_tile_proof.png"
MANIFEST = ROOT / "normalized_64x64" / "round170_water_pond_edge_ai_raw_sheet_v001_64x64_manifest.json"
ASSET_ATLAS = ASSET_DIR / "water_pond_edge_tiles_64x64_sheet_v001.png"
ASSET_PROOF = ASSET_DIR / "water_pond_edge_tiles_64x64_tile_proof_v001.png"
ASSET_MANIFEST = ASSET_DIR / "water_pond_edge_tiles_64x64_manifest_v001.json"
NORMALIZED_DIR = ROOT / "normalized_64x64"

KEY = np.array([255, 0, 255], dtype=np.int16)
KEY_HEX = "#ff00ff"
GRID_COLUMNS = 4
GRID_ROWS = 2
CELL_SIZE = (64, 64)
FIT_BOX = (60, 60)
PIVOT = (32, 32)
MIN_COMPONENT_PIXELS = 16
ITEM_IDS = [
    "water_pond_tile.01_center_water",
    "water_pond_tile.02_north_shoreline",
    "water_pond_tile.03_south_shoreline",
    "water_pond_tile.04_west_shoreline",
    "water_pond_tile.05_east_shoreline",
    "water_pond_tile.06_outer_corner",
    "water_pond_tile.07_inner_corner",
    "water_pond_tile.08_reed_accent",
]


def repo_path(path: Path) -> str:
    if path.is_absolute():
        return str(path.relative_to(Path.cwd()))
    return path.as_posix()


def alpha_from_key(rgb: np.ndarray) -> np.ndarray:
    dist = np.linalg.norm(rgb.astype(np.int16) - KEY, axis=2)
    alpha = np.clip((dist - 38.0) / 84.0, 0.0, 1.0) * 255.0
    return alpha.astype(np.uint8)


def bbox_from_alpha(alpha: np.ndarray) -> tuple[int, int, int, int] | None:
    ys, xs = np.where(alpha > 8)
    if len(xs) == 0:
        return None
    return int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1


def component_count(alpha: np.ndarray) -> int:
    mask = alpha > 8
    visited = np.zeros(mask.shape, dtype=bool)
    count = 0
    height, width = mask.shape
    for y in range(height):
        for x in range(width):
            if not mask[y, x] or visited[y, x]:
                continue
            pixels = 0
            queue: deque[tuple[int, int]] = deque([(x, y)])
            visited[y, x] = True
            while queue:
                cx, cy = queue.popleft()
                pixels += 1
                for nx, ny in ((cx + 1, cy), (cx - 1, cy), (cx, cy + 1), (cx, cy - 1)):
                    if nx < 0 or ny < 0 or nx >= width or ny >= height:
                        continue
                    if mask[ny, nx] and not visited[ny, nx]:
                        visited[ny, nx] = True
                        queue.append((nx, ny))
            if pixels >= MIN_COMPONENT_PIXELS:
                count += 1
    return count


def edge_touch(alpha: np.ndarray) -> dict[str, int]:
    return {
        "top": int(np.count_nonzero(alpha[0, :] > 8)),
        "bottom": int(np.count_nonzero(alpha[-1, :] > 8)),
        "left": int(np.count_nonzero(alpha[:, 0] > 8)),
        "right": int(np.count_nonzero(alpha[:, -1] > 8)),
    }


def visible_key_pixels(rgba: Image.Image, tolerance: float = 24.0) -> int:
    arr = np.array(rgba)
    rgb = arr[:, :, :3].astype(np.int16)
    alpha = arr[:, :, 3]
    dist = np.linalg.norm(rgb - KEY, axis=2)
    return int(np.count_nonzero((dist < tolerance) & (alpha > 8)))


def despill_key_pixels(rgba: Image.Image) -> Image.Image:
    arr = np.array(rgba)
    rgb = arr[:, :, :3].astype(np.int16)
    alpha = arr[:, :, 3]
    dist = np.linalg.norm(rgb - KEY, axis=2)
    near_key = (dist < 30) & (alpha > 0)
    arr[:, :, 3][near_key] = 0
    return Image.fromarray(arr, "RGBA")


def chroma_alpha(source: Image.Image) -> Image.Image:
    rgb = np.array(source.convert("RGB"))
    alpha = alpha_from_key(rgb)
    rgba = np.dstack([rgb, alpha])
    return despill_key_pixels(Image.fromarray(rgba, "RGBA"))


def normalize_cell(source_cell: Image.Image, index: int) -> tuple[Image.Image, dict]:
    cell_rgba = chroma_alpha(source_cell)
    alpha = np.array(cell_rgba)[:, :, 3]
    source_bbox = bbox_from_alpha(alpha)
    if source_bbox is None:
        normalized = Image.new("RGBA", CELL_SIZE, (0, 0, 0, 0))
        return normalized, {
            "index": index,
            "id": ITEM_IDS[index - 1],
            "status": "fail",
            "reasons": ["empty_source_cell"],
        }

    crop = cell_rgba.crop(source_bbox)
    scale = min(FIT_BOX[0] / crop.width, FIT_BOX[1] / crop.height)
    new_size = (max(1, round(crop.width * scale)), max(1, round(crop.height * scale)))
    resized = despill_key_pixels(crop.resize(new_size, Image.Resampling.LANCZOS))
    normalized = Image.new("RGBA", CELL_SIZE, (0, 0, 0, 0))
    x = int(round(PIVOT[0] - resized.width / 2))
    y = int(round(PIVOT[1] - resized.height / 2))
    normalized.alpha_composite(resized, (x, y))
    normalized = despill_key_pixels(normalized)

    normalized_path = NORMALIZED_DIR / f"water_pond_tile_{index:02d}_64x64.png"
    normalized.save(normalized_path)

    norm_alpha = np.array(normalized)[:, :, 3]
    placed_bbox = bbox_from_alpha(norm_alpha)
    margins = None
    if placed_bbox:
        margins = {
            "left": placed_bbox[0],
            "top": placed_bbox[1],
            "right": CELL_SIZE[0] - placed_bbox[2],
            "bottom": CELL_SIZE[1] - placed_bbox[3],
        }

    touches = edge_touch(norm_alpha)
    key_pixels = visible_key_pixels(normalized)
    components = component_count(norm_alpha)
    status = "pass"
    reasons: list[str] = []
    if key_pixels:
        status = "fail"
        reasons.append("visible_chroma_key_pixels")
    if components > 4:
        status = "warn" if status == "pass" else status
        reasons.append("many_small_components")

    return normalized, {
        "index": index,
        "id": ITEM_IDS[index - 1],
        "source_cell": {"row": (index - 1) // GRID_COLUMNS, "column": (index - 1) % GRID_COLUMNS},
        "source_bbox_in_cell": list(source_bbox),
        "normalized_png": repo_path(normalized_path),
        "cell_size": list(CELL_SIZE),
        "fit_box": list(FIT_BOX),
        "pivot_px": list(PIVOT),
        "placed_bbox": list(placed_bbox) if placed_bbox else None,
        "margins_px": margins,
        "edge_touch_count": touches,
        "edge_touch_allowed": True,
        "components": components,
        "max_components": 4,
        "visible_key_pixel_count": key_pixels,
        "scale_from_source_crop": scale,
        "status": status,
        "reasons": reasons,
    }


def make_tile_proof(atlas: Image.Image) -> Image.Image:
    proof = Image.new("RGBA", atlas.size, (228, 241, 230, 255))
    draw = ImageDraw.Draw(proof)
    for y in range(0, proof.height, 8):
        for x in range(0, proof.width, 8):
            if (x // 8 + y // 8) % 2:
                draw.rectangle((x, y, x + 7, y + 7), fill=(216, 232, 218, 255))
    proof.alpha_composite(atlas)
    draw = ImageDraw.Draw(proof)
    for row in range(GRID_ROWS):
        for column in range(GRID_COLUMNS):
            x0 = column * CELL_SIZE[0]
            y0 = row * CELL_SIZE[1]
            x1 = x0 + CELL_SIZE[0]
            y1 = y0 + CELL_SIZE[1]
            draw.rectangle((x0, y0, x1 - 1, y1 - 1), outline=(24, 90, 116, 220), width=1)
            draw.line((x0 + 32, y0, x0 + 32, y1), fill=(248, 245, 124, 150), width=1)
            draw.line((x0, y0 + 32, x1, y0 + 32), fill=(248, 245, 124, 150), width=1)
    return proof


def main() -> None:
    NORMALIZED_DIR.mkdir(parents=True, exist_ok=True)
    ASSET_DIR.mkdir(parents=True, exist_ok=True)

    source = Image.open(RAW).convert("RGB")
    alpha_source = chroma_alpha(source)
    alpha_source.save(ALPHA)
    width, height = source.size
    source_cell_w = width // GRID_COLUMNS
    source_cell_h = height // GRID_ROWS

    atlas = Image.new("RGBA", (GRID_COLUMNS * CELL_SIZE[0], GRID_ROWS * CELL_SIZE[1]), (0, 0, 0, 0))
    items = []
    for index in range(1, GRID_COLUMNS * GRID_ROWS + 1):
        column = (index - 1) % GRID_COLUMNS
        row = (index - 1) // GRID_COLUMNS
        crop_box = (
            column * source_cell_w,
            row * source_cell_h,
            (column + 1) * source_cell_w,
            (row + 1) * source_cell_h,
        )
        normalized, item = normalize_cell(source.crop(crop_box), index)
        atlas.alpha_composite(normalized, (column * CELL_SIZE[0], row * CELL_SIZE[1]))
        items.append(item)

    atlas.save(ATLAS)
    proof = make_tile_proof(atlas)
    proof.save(PROOF)

    gate_status = "pass"
    if any(item["status"] == "fail" for item in items):
        gate_status = "fail"
    elif any(item["status"] == "warn" for item in items):
        gate_status = "warn"

    manifest = {
        "status": "normalized_candidate",
        "round": "Round170",
        "worker": "E",
        "runtime_boundary": "proof_only_no_runtime_mapping_no_asset_resolver_no_theme_profile",
        "source": repo_path(RAW),
        "alpha_source": repo_path(ALPHA),
        "atlas": repo_path(ATLAS),
        "asset_tree_atlas": repo_path(ASSET_ATLAS),
        "tile_proof": repo_path(PROOF),
        "asset_tree_tile_proof": repo_path(ASSET_PROOF),
        "source_grid": {"columns": GRID_COLUMNS, "rows": GRID_ROWS},
        "cell_size": list(CELL_SIZE),
        "fit_box": list(FIT_BOX),
        "pivot_px": list(PIVOT),
        "key_color": KEY_HEX,
        "output_mode": "RGBA_transparent",
        "overall_gate": gate_status,
        "visible_key_pixel_count_atlas": visible_key_pixels(atlas),
        "raw_size_px": [width, height],
        "atlas_size_px": list(atlas.size),
        "tile_edge_note": "Edge alpha touch is recorded but allowed for water/shoreline tiles because tileable fills and edges may intentionally reach cell borders.",
        "items": items,
    }
    MANIFEST.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    shutil.copy2(ATLAS, ASSET_ATLAS)
    shutil.copy2(PROOF, ASSET_PROOF)
    shutil.copy2(MANIFEST, ASSET_MANIFEST)
    print(json.dumps({"overall_gate": gate_status, "atlas": repo_path(ATLAS), "asset_tree_atlas": repo_path(ASSET_ATLAS)}, indent=2))


if __name__ == "__main__":
    main()
