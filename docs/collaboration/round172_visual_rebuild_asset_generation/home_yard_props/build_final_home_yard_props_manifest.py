#!/usr/bin/env python3
"""Build the final Round172 home yard props atlas, proof, and manifest."""

from __future__ import annotations

import json
from collections import deque
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ASSET_DIR = Path("assets/art/visual_rebuild/round172/home_yard_props")
NORMALIZED_DIR = ASSET_DIR / "normalized_128x128"
ATLAS_PATH = ASSET_DIR / "home_yard_props_128x128_atlas.png"
PROOF_PATH = ASSET_DIR / "home_yard_props_128x128_proof.png"
MANIFEST_PATH = ASSET_DIR / "home_yard_props_manifest.json"
SOURCE_PATH = Path("docs/collaboration/round172_visual_rebuild_asset_generation/home_yard_props/home_yard_props_raw_chroma_ff00ff_flat_v3.png")
SOURCE_ALPHA_PATH = ASSET_DIR / "home_yard_props_raw_chroma_ff00ff_flat_v3_chroma_alpha.png"
CELL_SIZE = 128
PIVOT = (64, 118)
ITEMS = [
    ("home_yard_prop.watering_can", "watering can", "home_yard_prop_01_128x128.png"),
    ("home_yard_prop.flower_pot_cluster", "flower pot cluster", "home_yard_prop_02_128x128.png"),
    ("home_yard_prop.tiny_birdhouse", "tiny birdhouse", "home_yard_prop_03_128x128.png"),
    ("home_yard_prop.garden_bed", "garden bed", "home_yard_prop_04_128x128.png"),
    ("home_yard_prop.folded_picnic_cloth", "folded picnic cloth", "home_yard_prop_05_128x128.png"),
    ("home_yard_prop.pet_bowl", "pet bowl", "home_yard_prop_06_128x128.png"),
    ("home_yard_prop.laundry_line_post", "laundry line post", "home_yard_prop_07_128x128.png"),
    ("home_yard_prop.stepping_stones", "small stepping stones", "home_yard_prop_08_128x128.png"),
]


def component_count(alpha: Image.Image, threshold: int = 48, min_area: int = 8) -> int:
    width, height = alpha.size
    pixels = alpha.load()
    seen = [bytearray(width) for _ in range(height)]
    count = 0
    for sy in range(height):
        for sx in range(width):
            if seen[sy][sx] or pixels[sx, sy] < threshold:
                continue
            queue = deque([(sx, sy)])
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


def edge_touch_count(alpha: Image.Image) -> dict[str, int]:
    width, height = alpha.size
    pixels = alpha.load()
    return {
        "top": sum(1 for x in range(width) if pixels[x, 0] > 0),
        "bottom": sum(1 for x in range(width) if pixels[x, height - 1] > 0),
        "left": sum(1 for y in range(height) if pixels[0, y] > 0),
        "right": sum(1 for y in range(height) if pixels[width - 1, y] > 0),
    }


def visible_key_pixel_count(image: Image.Image) -> int:
    rgba = image.convert("RGBA")
    pixels = rgba.load()
    count = 0
    for y in range(rgba.height):
        for x in range(rgba.width):
            red, green, blue, alpha = pixels[x, y]
            if alpha > 0 and red > 210 and blue > 210 and green < 80:
                count += 1
    return count


def load_font(size: int) -> ImageFont.ImageFont | ImageFont.FreeTypeFont:
    font_path = Path("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf")
    if font_path.exists():
        return ImageFont.truetype(str(font_path), size)
    return ImageFont.load_default()


def build_proof(atlas: Image.Image) -> None:
    proof = Image.new("RGBA", atlas.size, (238, 238, 232, 255))
    draw = ImageDraw.Draw(proof)
    for y in range(0, atlas.height, 16):
        for x in range(0, atlas.width, 16):
            if (x // 16 + y // 16) % 2:
                draw.rectangle([x, y, x + 15, y + 15], fill=(225, 225, 218, 255))
    proof.alpha_composite(atlas)
    font = load_font(10)
    for index in range(8):
        column = index % 4
        row = index // 4
        x0 = column * CELL_SIZE
        y0 = row * CELL_SIZE
        x1 = x0 + CELL_SIZE - 1
        y1 = y0 + CELL_SIZE - 1
        px = x0 + PIVOT[0]
        py = y0 + PIVOT[1]
        draw.rectangle([x0, y0, x1, y1], outline=(52, 84, 120, 255), width=2)
        draw.line([x0, py, x1, py], fill=(220, 80, 70, 220), width=2)
        draw.ellipse([px - 4, py - 4, px + 4, py + 4], fill=(255, 230, 70, 255), outline=(20, 20, 20, 255))
        draw.text((x0 + 4, y0 + 4), str(index + 1), fill=(20, 20, 20, 255), font=font)
    proof.save(PROOF_PATH)


def main() -> None:
    atlas = Image.new("RGBA", (CELL_SIZE * 4, CELL_SIZE * 2), (0, 0, 0, 0))
    manifest_items = []
    for index, (logical_id, name, filename) in enumerate(ITEMS, start=1):
        image_path = NORMALIZED_DIR / filename
        image = Image.open(image_path).convert("RGBA")
        column = (index - 1) % 4
        row = (index - 1) // 4
        atlas.alpha_composite(image, (column * CELL_SIZE, row * CELL_SIZE))

        alpha = image.getchannel("A")
        bbox = alpha.getbbox()
        edges = edge_touch_count(alpha)
        visible_key = visible_key_pixel_count(image)
        has_alpha = image.mode == "RGBA"
        gate_pass = (
            image.size == (CELL_SIZE, CELL_SIZE)
            and has_alpha
            and bbox is not None
            and visible_key == 0
            and all(value == 0 for value in edges.values())
        )
        manifest_items.append({
            "index": index,
            "id": logical_id,
            "display_name": name,
            "normalized_png": str(image_path),
            "atlas_cell": {"row": row, "column": column},
            "cell_size": [CELL_SIZE, CELL_SIZE],
            "pivot_px": list(PIVOT),
            "bbox": list(bbox) if bbox else None,
            "edge_touch_count": edges,
            "component_count": component_count(alpha),
            "visible_key_pixel_count": visible_key,
            "has_alpha": has_alpha,
            "status": "pass" if gate_pass else "needs_review",
        })

    atlas.save(ATLAS_PATH)
    build_proof(atlas)
    atlas_visible_key = visible_key_pixel_count(atlas)
    fixed_cell = all(item["cell_size"] == [CELL_SIZE, CELL_SIZE] for item in manifest_items)
    all_alpha = all(item["has_alpha"] for item in manifest_items) and atlas.mode == "RGBA"
    all_bbox = all(item["bbox"] is not None for item in manifest_items)
    all_key_clear = all(item["visible_key_pixel_count"] == 0 for item in manifest_items) and atlas_visible_key == 0
    overall_gate = "pass" if fixed_cell and all_alpha and all_bbox and all_key_clear else "needs_review"

    manifest = {
        "round": "Round172",
        "pack_id": "home_yard_props",
        "status": "normalized_candidate",
        "runtime_boundary": "candidate_only_no_asset_resolver_or_themeprofile_mapping",
        "source": str(SOURCE_PATH),
        "alpha_source": str(SOURCE_ALPHA_PATH),
        "atlas": str(ATLAS_PATH),
        "proof": str(PROOF_PATH),
        "source_grid": {"columns": 4, "rows": 2},
        "cell_size": [CELL_SIZE, CELL_SIZE],
        "atlas_size": [CELL_SIZE * 4, CELL_SIZE * 2],
        "key_color": "#ff00ff",
        "gate_checks": {
            "fixed_cell": fixed_cell,
            "alpha": all_alpha,
            "bbox": all_bbox,
            "visible_key_pixels": atlas_visible_key,
            "visible_key_pixels_zero": all_key_clear,
        },
        "overall_gate": overall_gate,
        "items": manifest_items,
        "notes": [
            "Proof-only asset pack; not wired to runtime mappings.",
            "Generated with local image_generator.js and normalized through chroma-key alpha removal.",
            "Right-edge cross-cell spill was cleared on birdhouse and laundry-line cells before final atlas build."
        ],
    }
    MANIFEST_PATH.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({
        "atlas": str(ATLAS_PATH),
        "proof": str(PROOF_PATH),
        "manifest": str(MANIFEST_PATH),
        "overall_gate": overall_gate,
        "gate_checks": manifest["gate_checks"],
        "item_status": [item["status"] for item in manifest_items],
    }, indent=2))


if __name__ == "__main__":
    main()
