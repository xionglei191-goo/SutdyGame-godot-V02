#!/usr/bin/env python3
"""Extract Round172 town props from a chroma-key raw sheet.

This proof-only helper keeps the raw generation sheet as provenance, but avoids
strict grid slicing because some generated props slightly cross their implied
cell boundaries.
"""

from __future__ import annotations

import json
from collections import deque
from pathlib import Path

from PIL import Image, ImageDraw


ROOT = Path(__file__).resolve().parents[4]
SOURCE = ROOT / "docs/collaboration/round172_visual_rebuild_asset_generation/town_props/round172_town_props_raw_chroma_4x2_v002.png"
OUT_DIR = ROOT / "assets/art/visual_rebuild/round172/town_props"
NORMALIZED_DIR = OUT_DIR / "normalized_128x128"
CELL_W = 128
CELL_H = 128
PIVOT = (64, 122)
FIT_W = 112
FIT_H = 116
KEY_COLOR = "#ff00ff"


ITEMS = [
    {
        "index": 1,
        "label": "mailbox",
        "logical_candidate_id": "round172.town_props.mailbox",
        "source_cell": {"row": 0, "column": 0},
        "source_bbox_full": [62, 50, 224, 210],
    },
    {
        "index": 2,
        "label": "warm street lamp",
        "logical_candidate_id": "round172.town_props.warm_street_lamp",
        "source_cell": {"row": 0, "column": 1},
        "source_bbox_full": [272, 8, 450, 214],
    },
    {
        "index": 3,
        "label": "wood signpost",
        "logical_candidate_id": "round172.town_props.wood_signpost",
        "source_cell": {"row": 0, "column": 2},
        "source_bbox_full": [490, 40, 685, 210],
    },
    {
        "index": 4,
        "label": "wood crate stack",
        "logical_candidate_id": "round172.town_props.wood_crate_stack",
        "source_cell": {"row": 0, "column": 3},
        "source_bbox_full": [680, 50, 955, 215],
    },
    {
        "index": 5,
        "label": "small notice board",
        "logical_candidate_id": "round172.town_props.small_notice_board",
        "source_cell": {"row": 1, "column": 0},
        "source_bbox_full": [45, 280, 255, 425],
    },
    {
        "index": 6,
        "label": "round stone",
        "logical_candidate_id": "round172.town_props.round_stone",
        "source_cell": {"row": 1, "column": 1},
        "source_bbox_full": [280, 295, 480, 405],
    },
    {
        "index": 7,
        "label": "small wooden bench",
        "logical_candidate_id": "round172.town_props.small_wooden_bench",
        "source_cell": {"row": 1, "column": 2},
        "source_bbox_full": [485, 300, 730, 435],
    },
    {
        "index": 8,
        "label": "market basket",
        "logical_candidate_id": "round172.town_props.market_basket",
        "source_cell": {"row": 1, "column": 3},
        "source_bbox_full": [735, 270, 970, 440],
    },
]


def is_magenta_like(pixel: tuple[int, int, int, int]) -> bool:
    red, green, blue, alpha = pixel
    if alpha == 0:
        return True
    return (
        red > 90
        and blue > 90
        and green < 120
        and red + blue - 2 * green > 125
        and abs(red - blue) < 120
    )


def remove_edge_background(image: Image.Image) -> Image.Image:
    image = image.convert("RGBA")
    width, height = image.size
    pixels = image.load()
    mask = [bytearray(width) for _ in range(height)]
    queue: deque[tuple[int, int]] = deque()

    def enqueue(x: int, y: int) -> None:
        if mask[y][x] or not is_magenta_like(pixels[x, y]):
            return
        mask[y][x] = 1
        queue.append((x, y))

    for x in range(width):
        enqueue(x, 0)
        enqueue(x, height - 1)
    for y in range(height):
        enqueue(0, y)
        enqueue(width - 1, y)

    while queue:
        x, y = queue.popleft()
        for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
            if 0 <= nx < width and 0 <= ny < height:
                enqueue(nx, ny)

    out = Image.new("RGBA", image.size, (0, 0, 0, 0))
    out_pixels = out.load()
    for y in range(height):
        for x in range(width):
            if not mask[y][x]:
                out_pixels[x, y] = pixels[x, y]
    return out


def visible_key_pixel_count(image: Image.Image) -> int:
    pixels = image.load()
    width, height = image.size
    count = 0
    for y in range(height):
        for x in range(width):
            if pixels[x, y][3] > 0 and is_magenta_like(pixels[x, y]):
                count += 1
    return count


def clear_visible_key_pixels(image: Image.Image) -> None:
    pixels = image.load()
    width, height = image.size
    for y in range(height):
        for x in range(width):
            if pixels[x, y][3] > 0 and is_magenta_like(pixels[x, y]):
                pixels[x, y] = (0, 0, 0, 0)


def edge_touch_count(alpha: Image.Image) -> dict[str, int]:
    width, height = alpha.size
    pixels = alpha.load()
    return {
        "top": sum(1 for x in range(width) if pixels[x, 0] > 0),
        "bottom": sum(1 for x in range(width) if pixels[x, height - 1] > 0),
        "left": sum(1 for y in range(height) if pixels[0, y] > 0),
        "right": sum(1 for y in range(height) if pixels[width - 1, y] > 0),
    }


def component_count(alpha: Image.Image, threshold: int = 64, min_area: int = 18) -> int:
    width, height = alpha.size
    pixels = alpha.load()
    seen = [bytearray(width) for _ in range(height)]
    count = 0
    for sy in range(height):
        for sx in range(width):
            if seen[sy][sx] or pixels[sx, sy] < threshold:
                continue
            queue: deque[tuple[int, int]] = deque([(sx, sy)])
            seen[sy][sx] = 1
            area = 0
            while queue:
                x, y = queue.popleft()
                area += 1
                for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                    if 0 <= nx < width and 0 <= ny < height and not seen[ny][nx] and pixels[nx, ny] >= threshold:
                        seen[ny][nx] = 1
                        queue.append((nx, ny))
            if area >= min_area:
                count += 1
    return count


def save_proof(atlas: Image.Image, proof_path: Path) -> None:
    proof = Image.new("RGBA", atlas.size, (238, 238, 232, 255))
    draw = ImageDraw.Draw(proof)
    for y in range(0, proof.height, 16):
        for x in range(0, proof.width, 16):
            if (x // 16 + y // 16) % 2:
                draw.rectangle([x, y, x + 15, y + 15], fill=(225, 225, 218, 255))
    proof.alpha_composite(atlas)
    for row in range(2):
        for col in range(4):
            x0 = col * CELL_W
            y0 = row * CELL_H
            px = x0 + PIVOT[0]
            py = y0 + PIVOT[1]
            draw.rectangle([x0, y0, x0 + CELL_W - 1, y0 + CELL_H - 1], outline=(52, 84, 120, 255), width=2)
            draw.line([x0, py, x0 + CELL_W - 1, py], fill=(220, 80, 70, 220), width=2)
            draw.ellipse([px - 4, py - 4, px + 4, py + 4], fill=(255, 230, 70, 255), outline=(20, 20, 20, 255))
    proof.save(proof_path)


def normalize_item(source_alpha: Image.Image, item: dict) -> tuple[Image.Image, dict]:
    crop = source_alpha.crop(item["source_bbox_full"])
    bbox = crop.getchannel("A").getbbox()
    if bbox is None:
        raise RuntimeError(f"empty crop for {item['label']}")
    subject = crop.crop(bbox)
    source_crop_w, source_crop_h = subject.size
    scale = min(FIT_W / source_crop_w, FIT_H / source_crop_h, 1.0)
    target_w = max(1, round(source_crop_w * scale))
    target_h = max(1, round(source_crop_h * scale))
    subject = subject.resize((target_w, target_h), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (CELL_W, CELL_H), (0, 0, 0, 0))
    origin_x = PIVOT[0] - target_w // 2
    origin_y = PIVOT[1] - target_h
    canvas.alpha_composite(subject, (origin_x, origin_y))
    clear_visible_key_pixels(canvas)

    alpha = canvas.getchannel("A")
    placed_bbox = alpha.getbbox()
    if placed_bbox is None:
        raise RuntimeError(f"empty normalized item for {item['label']}")
    left, top, right, bottom = placed_bbox
    margins = {
        "left": left,
        "top": top,
        "right": CELL_W - right,
        "bottom": CELL_H - bottom,
    }
    edges = edge_touch_count(alpha)
    components = component_count(alpha)
    key_pixels = visible_key_pixel_count(canvas)
    gate_pass = (
        canvas.mode == "RGBA"
        and canvas.size == (CELL_W, CELL_H)
        and placed_bbox is not None
        and all(value == 0 for value in edges.values())
        and key_pixels == 0
        and margins["left"] >= 3
        and margins["right"] >= 3
        and margins["top"] >= 3
        and margins["bottom"] >= 3
    )

    normalized_name = f"round172_town_prop_{item['index']:02d}_128x128.png"
    normalized_path = NORMALIZED_DIR / normalized_name
    canvas.save(normalized_path)
    record = {
        "index": item["index"],
        "id": f"round172_town_prop.{item['index']:02d}",
        "logical_candidate_id": item["logical_candidate_id"],
        "label": item["label"],
        "source_cell": item["source_cell"],
        "source_bbox_full": item["source_bbox_full"],
        "source_bbox_in_crop": list(bbox),
        "normalized_png": str(normalized_path.relative_to(ROOT)),
        "cell_size": [CELL_W, CELL_H],
        "pivot_px": list(PIVOT),
        "placed_bbox": list(placed_bbox),
        "margins_px": margins,
        "edge_touch_count": edges,
        "components": components,
        "max_components": 4,
        "visible_key_pixel_count": key_pixels,
        "scale_from_source_crop": scale,
        "status": "pass" if gate_pass else "needs_review",
    }
    return canvas, record


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    NORMALIZED_DIR.mkdir(parents=True, exist_ok=True)

    raw = Image.open(SOURCE).convert("RGBA")
    alpha_source = remove_edge_background(raw)
    alpha_source_path = OUT_DIR / "round172_town_props_raw_chroma_4x2_v002_chroma_alpha.png"
    alpha_source.save(alpha_source_path)

    atlas = Image.new("RGBA", (4 * CELL_W, 2 * CELL_H), (0, 0, 0, 0))
    records = []
    for item in ITEMS:
        canvas, record = normalize_item(alpha_source, item)
        col = (item["index"] - 1) % 4
        row = (item["index"] - 1) // 4
        atlas.alpha_composite(canvas, (col * CELL_W, row * CELL_H))
        records.append(record)

    atlas_path = OUT_DIR / "round172_town_props_raw_chroma_4x2_v002_128x128_atlas.png"
    proof_path = OUT_DIR / "round172_town_props_raw_chroma_4x2_v002_128x128_pivot_proof.png"
    manifest_path = OUT_DIR / "round172_town_props_raw_chroma_4x2_v002_128x128_manifest.json"
    atlas.save(atlas_path)
    save_proof(atlas, proof_path)

    manifest = {
        "asset_pack_id": "round172.town_props",
        "round": "round172",
        "category": "town_props",
        "status": "normalized_candidate",
        "runtime_boundary": "candidate_only_no_asset_resolver_or_themeprofile_mapping",
        "approval_boundary": "proof_only_not_final_approved",
        "style_target": "cozy mobile life RPG town props, warm hand-painted 3/4 view, fixed-cell transparent-ready atlas",
        "raw_generation": {
            "tool": "/home/xionglei/GameProject/tools/image_generator.js",
            "mode": "text",
            "output": "docs/collaboration/round172_visual_rebuild_asset_generation/town_props/round172_town_props_raw_chroma_4x2_v002.png",
            "size": "1024x512",
            "chroma_key": KEY_COLOR,
        },
        "source": str(SOURCE.relative_to(ROOT)),
        "source_note": "Raw sheet was not used as a strict crop grid because generated wide props crossed implied cell boundaries; manual source bboxes preserve the same raw sheet while producing clean fixed cells.",
        "alpha_source": str(alpha_source_path.relative_to(ROOT)),
        "atlas": str(atlas_path.relative_to(ROOT)),
        "pivot_proof": str(proof_path.relative_to(ROOT)),
        "source_grid": {"columns": 4, "rows": 2},
        "cell_size": [CELL_W, CELL_H],
        "fit_box": [FIT_W, FIT_H],
        "pivot_px": list(PIVOT),
        "key_color": KEY_COLOR,
        "key_family": "magenta",
        "item_catalog": [
            {
                "index": record["index"],
                "logical_candidate_id": record["logical_candidate_id"],
                "label": record["label"],
                "normalized_png": record["normalized_png"],
            }
            for record in records
        ],
        "gate_requirements": {
            "fixed_cell": "128x128 for every normalized PNG and atlas cell",
            "alpha": "RGBA normalized PNG / atlas with transparent background",
            "bbox": "each item must have a non-empty placed_bbox",
            "visible_key_pixels": 0,
            "overall_gate_policy": "pass only when fixed cell, alpha, bbox, and visible key pixels=0 all pass",
        },
        "items": records,
        "overall_gate": "pass" if all(record["status"] == "pass" for record in records) else "needs_review",
    }
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({
        "atlas": str(atlas_path.relative_to(ROOT)),
        "pivot_proof": str(proof_path.relative_to(ROOT)),
        "manifest": str(manifest_path.relative_to(ROOT)),
        "overall_gate": manifest["overall_gate"],
        "item_status": [record["status"] for record in records],
    }, indent=2))


if __name__ == "__main__":
    main()
