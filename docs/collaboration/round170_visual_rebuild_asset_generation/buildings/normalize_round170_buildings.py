#!/usr/bin/env python3
"""Round170 building prefab chroma normalization helper.

Proof-local only: this script creates transparent candidate cells, an atlas,
and numeric gates without wiring anything into runtime mappings.
"""

from __future__ import annotations

import json
from collections import deque
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parent
ASSET_DIR = Path("assets/art/visual_rebuild/round170/buildings")
RAW = ROOT / "raw" / "round170_building_prefabs_ai_raw_sheet_v001.png"
ALPHA = ROOT / "round170_building_prefabs_ai_raw_sheet_v001_chroma_alpha.png"
ATLAS = ROOT / "round170_building_prefabs_320x320_atlas_v001.png"
PIVOT_PROOF = ROOT / "round170_building_prefabs_320x320_pivot_proof_v001.png"
MANIFEST = ROOT / "round170_building_prefabs_320x320_manifest_v001.json"
NORMALIZED_DIR = ROOT / "normalized_320x320"
ASSET_ATLAS = ASSET_DIR / "building_prefabs_320x320_atlas_v001.png"
ASSET_PROOF = ASSET_DIR / "building_prefabs_320x320_pivot_proof_v001.png"
ASSET_MANIFEST = ASSET_DIR / "building_prefabs_320x320_manifest_v001.json"

KEY = np.array([255, 0, 255], dtype=np.int16)
GRID_COLUMNS = 2
GRID_ROWS = 2
CELL_SIZE = (320, 320)
FIT_BOX = (286, 282)
PIVOT = (160, 302)
MIN_COMPONENT_PIXELS = 48

ITEM_IDS = [
    "building_prefab.01_home_red_roof",
    "building_prefab.02_shop_green_awning",
    "building_prefab.03_garden_blue_roof",
    "building_prefab.04_community_yellow_roof",
]


def repo_path(path: Path) -> str:
    if path.is_absolute():
        return str(path.relative_to(Path.cwd()))
    return path.as_posix()


def alpha_from_key(rgb: np.ndarray) -> np.ndarray:
    dist = np.linalg.norm(rgb.astype(np.int16) - KEY, axis=2)
    alpha = np.clip((dist - 44.0) / 92.0, 0.0, 1.0) * 255.0
    return alpha.astype(np.uint8)


def bbox_from_alpha(alpha: np.ndarray) -> tuple[int, int, int, int] | None:
    ys, xs = np.where(alpha > 8)
    if len(xs) == 0:
        return None
    return int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1


def component_count(alpha: np.ndarray) -> int:
    mask = alpha > 8
    visited = np.zeros(mask.shape, dtype=bool)
    height, width = mask.shape
    count = 0
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


def keep_largest_component(rgba: Image.Image) -> Image.Image:
    arr = np.array(rgba)
    mask = arr[:, :, 3] > 8
    visited = np.zeros(mask.shape, dtype=bool)
    height, width = mask.shape
    components: list[list[tuple[int, int]]] = []
    for y in range(height):
        for x in range(width):
            if not mask[y, x] or visited[y, x]:
                continue
            pixels: list[tuple[int, int]] = []
            queue: deque[tuple[int, int]] = deque([(x, y)])
            visited[y, x] = True
            while queue:
                cx, cy = queue.popleft()
                pixels.append((cx, cy))
                for nx, ny in ((cx + 1, cy), (cx - 1, cy), (cx, cy + 1), (cx, cy - 1)):
                    if nx < 0 or ny < 0 or nx >= width or ny >= height:
                        continue
                    if mask[ny, nx] and not visited[ny, nx]:
                        visited[ny, nx] = True
                        queue.append((nx, ny))
            components.append(pixels)

    if not components:
        return rgba

    keep = set(max(components, key=len))
    for y in range(height):
        for x in range(width):
            if arr[y, x, 3] > 0 and (x, y) not in keep:
                arr[y, x, 3] = 0
    return Image.fromarray(arr, "RGBA")


def edge_touch(alpha: np.ndarray) -> dict[str, int]:
    return {
        "top": int(np.count_nonzero(alpha[0, :] > 8)),
        "bottom": int(np.count_nonzero(alpha[-1, :] > 8)),
        "left": int(np.count_nonzero(alpha[:, 0] > 8)),
        "right": int(np.count_nonzero(alpha[:, -1] > 8)),
    }


def visible_key_pixels(rgba: Image.Image) -> int:
    arr = np.array(rgba)
    rgb = arr[:, :, :3].astype(np.int16)
    alpha = arr[:, :, 3]
    dist = np.linalg.norm(rgb - KEY, axis=2)
    return int(np.count_nonzero((dist < 28) & (alpha > 8)))


def despill_key_pixels(rgba: Image.Image) -> Image.Image:
    arr = np.array(rgba)
    rgb = arr[:, :, :3].astype(np.int16)
    alpha = arr[:, :, 3]
    dist = np.linalg.norm(rgb - KEY, axis=2)
    near_key = (dist < 32) & (alpha > 0)
    arr[:, :, 3][near_key] = 0
    return Image.fromarray(arr, "RGBA")


def chroma_alpha(source: Image.Image) -> Image.Image:
    rgb = np.array(source.convert("RGB"))
    alpha = alpha_from_key(rgb)
    return despill_key_pixels(Image.fromarray(np.dstack([rgb, alpha]), "RGBA"))


def normalize_cell(source_cell: Image.Image, index: int) -> tuple[Image.Image, dict]:
    cell_rgba = keep_largest_component(chroma_alpha(source_cell))
    alpha = np.array(cell_rgba)[:, :, 3]
    source_bbox = bbox_from_alpha(alpha)
    if source_bbox is None:
        blank = Image.new("RGBA", CELL_SIZE, (0, 0, 0, 0))
        return blank, {"index": index, "status": "fail", "reasons": ["empty_source_cell"]}

    crop = cell_rgba.crop(source_bbox)
    crop_alpha = np.array(crop)[:, :, 3]
    crop_bbox = bbox_from_alpha(crop_alpha)
    if crop_bbox is not None:
        crop = crop.crop(crop_bbox)

    scale = min(FIT_BOX[0] / crop.width, FIT_BOX[1] / crop.height)
    new_size = (max(1, round(crop.width * scale)), max(1, round(crop.height * scale)))
    resized = despill_key_pixels(crop.resize(new_size, Image.Resampling.LANCZOS))

    normalized = Image.new("RGBA", CELL_SIZE, (0, 0, 0, 0))
    x = int(round(PIVOT[0] - resized.width / 2))
    y = int(round(PIVOT[1] - resized.height))
    normalized.alpha_composite(resized, (x, y))
    normalized = keep_largest_component(despill_key_pixels(normalized))

    normalized_path = NORMALIZED_DIR / f"building_prefab_{index:02d}_320x320.png"
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
    if any(touches.values()):
        status = "fail"
        reasons.append("alpha_touches_cell_edge")
    if key_pixels:
        status = "fail"
        reasons.append("visible_chroma_key_pixels")
    if margins and (margins["left"] < 8 or margins["right"] < 8 or margins["bottom"] < 8):
        status = "fail"
        reasons.append("insufficient_cell_margin")
    if components != 1:
        status = "warn" if status == "pass" else status
        reasons.append("component_count_not_one")

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
        "components": components,
        "max_components": 1,
        "visible_key_pixel_count": key_pixels,
        "scale_from_source_crop": scale,
        "status": status,
        "reasons": reasons,
    }


def load_font(size: int) -> ImageFont.ImageFont | ImageFont.FreeTypeFont:
    font_path = Path("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf")
    if font_path.exists():
        return ImageFont.truetype(str(font_path), size)
    return ImageFont.load_default()


def make_pivot_proof(atlas: Image.Image) -> Image.Image:
    proof = Image.new("RGBA", atlas.size, (241, 239, 232, 255))
    draw = ImageDraw.Draw(proof)
    for y in range(0, proof.height, 16):
        for x in range(0, proof.width, 16):
            if (x // 16 + y // 16) % 2:
                draw.rectangle((x, y, x + 15, y + 15), fill=(229, 228, 220, 255))
    proof.alpha_composite(atlas)
    draw = ImageDraw.Draw(proof)
    font = load_font(16)
    for row in range(GRID_ROWS):
        for column in range(GRID_COLUMNS):
            x0 = column * CELL_SIZE[0]
            y0 = row * CELL_SIZE[1]
            x1 = x0 + CELL_SIZE[0]
            y1 = y0 + CELL_SIZE[1]
            baseline = y0 + PIVOT[1]
            pivot_x = x0 + PIVOT[0]
            draw.rectangle((x0, y0, x1 - 1, y1 - 1), outline=(42, 72, 106, 220), width=2)
            draw.line((x0, baseline, x1, baseline), fill=(230, 76, 56, 230), width=2)
            draw.line((pivot_x - 8, baseline, pivot_x + 8, baseline), fill=(22, 22, 22, 255), width=2)
            draw.line((pivot_x, baseline - 8, pivot_x, baseline + 8), fill=(22, 22, 22, 255), width=2)
            draw.text((x0 + 8, y0 + 8), str(row * GRID_COLUMNS + column + 1), fill=(20, 20, 20, 255), font=font)
    return proof


def main() -> None:
    NORMALIZED_DIR.mkdir(parents=True, exist_ok=True)
    ASSET_DIR.mkdir(parents=True, exist_ok=True)

    source = Image.open(RAW).convert("RGB")
    alpha_source = chroma_alpha(source)
    alpha_source.save(ALPHA)

    source_cell_w = source.width // GRID_COLUMNS
    source_cell_h = source.height // GRID_ROWS
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
    atlas.save(ASSET_ATLAS)
    proof = make_pivot_proof(atlas)
    proof.save(PIVOT_PROOF)
    proof.save(ASSET_PROOF)

    overall = "pass" if all(item["status"] == "pass" for item in items) else "fail"
    manifest = {
        "status": "normalized_candidate",
        "overall_gate": overall,
        "source": repo_path(RAW),
        "alpha_source": repo_path(ALPHA),
        "atlas": repo_path(ATLAS),
        "pivot_proof": repo_path(PIVOT_PROOF),
        "asset_tree_atlas": repo_path(ASSET_ATLAS),
        "asset_tree_pivot_proof": repo_path(ASSET_PROOF),
        "source_grid": {"columns": GRID_COLUMNS, "rows": GRID_ROWS},
        "cell_size": list(CELL_SIZE),
        "fit_box": list(FIT_BOX),
        "pivot_px": list(PIVOT),
        "key_color": "#ff00ff",
        "items": items,
    }
    MANIFEST.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    ASSET_MANIFEST.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"overall_gate": overall, "items": items}, indent=2))


if __name__ == "__main__":
    main()
