#!/usr/bin/env python3
"""Normalize Round173 cozy furniture candidates into fixed-cell alpha sprites."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ITEMS = [
    ("small_table", "Small Table", "furniture.small_table.placed"),
    ("wooden_chair", "Wooden Chair", "furniture.wooden_chair.placed"),
    ("round_rug", "Round Rug", "furniture.rug_round.placed"),
    ("flower_pot", "Flower Pot", "furniture.flower_pot.placed"),
    ("pet_bowl", "Pet Bowl", "furniture.pet_bowl.placed"),
    ("sunny_bed", "Sunny Bed", "furniture.sunny_bed.placed"),
    ("book_stack", "Book Stack", "furniture.book_stack.placed"),
    ("wall_art", "Wall Art", "furniture.wall_art.placed"),
]

KEY_RGB = (255, 0, 255)


def color_distance(a: tuple[int, int, int], b: tuple[int, int, int]) -> int:
    return abs(a[0] - b[0]) + abs(a[1] - b[1]) + abs(a[2] - b[2])


def make_checker(size: tuple[int, int], block: int = 8) -> Image.Image:
    image = Image.new("RGBA", size, (244, 238, 226, 255))
    draw = ImageDraw.Draw(image)
    for y in range(0, size[1], block):
        for x in range(0, size[0], block):
            if (x // block + y // block) % 2:
                draw.rectangle((x, y, x + block - 1, y + block - 1), fill=(220, 232, 222, 255))
    return image


def alpha_from_key(cell: Image.Image, threshold: int) -> Image.Image:
    rgb = cell.convert("RGB")
    alpha = Image.new("L", rgb.size, 0)
    source = rgb.load()
    target = alpha.load()
    for y in range(rgb.height):
        for x in range(rgb.width):
            if color_distance(source[x, y], KEY_RGB) > threshold:
                target[x, y] = 255
    return alpha


def bbox_for_alpha(image: Image.Image) -> tuple[int, int, int, int] | None:
    return image.getchannel("A").getbbox()


def count_visible_key_pixels(image: Image.Image, threshold: int) -> int:
    rgba = image.convert("RGBA")
    pixels = rgba.load()
    count = 0
    for y in range(rgba.height):
        for x in range(rgba.width):
            r, g, b, a = pixels[x, y]
            if a > 0 and color_distance((r, g, b), KEY_RGB) <= threshold:
                count += 1
    return count


def remove_visible_key_pixels(image: Image.Image, threshold: int) -> Image.Image:
    cleaned = image.convert("RGBA")
    pixels = cleaned.load()
    for y in range(cleaned.height):
        for x in range(cleaned.width):
            r, g, b, a = pixels[x, y]
            if a > 0 and color_distance((r, g, b), KEY_RGB) <= threshold:
                pixels[x, y] = (r, g, b, 0)
    return cleaned


def edge_touch_count(bbox: tuple[int, int, int, int], width: int, height: int) -> dict[str, int]:
    left, top, right, bottom = bbox
    return {
        "top": 1 if top <= 0 else 0,
        "bottom": 1 if bottom >= height else 0,
        "left": 1 if left <= 0 else 0,
        "right": 1 if right >= width else 0,
    }


def count_components(alpha: Image.Image) -> int:
    mask = alpha.point(lambda value: 1 if value > 0 else 0)
    pixels = mask.load()
    width, height = mask.size
    seen = [[False for _x in range(width)] for _y in range(height)]
    components = 0
    for y in range(height):
        for x in range(width):
            if seen[y][x] or not pixels[x, y]:
                continue
            components += 1
            stack = [(x, y)]
            seen[y][x] = True
            while stack:
                cx, cy = stack.pop()
                for nx, ny in ((cx + 1, cy), (cx - 1, cy), (cx, cy + 1), (cx, cy - 1)):
                    if 0 <= nx < width and 0 <= ny < height and not seen[ny][nx] and pixels[nx, ny]:
                        seen[ny][nx] = True
                        stack.append((nx, ny))
    return components


def extract_alpha_sprite(cell: Image.Image, threshold: int) -> Image.Image:
    rgba = cell.convert("RGBA")
    rgba.putalpha(alpha_from_key(rgba, threshold))
    return rgba


def normalize_cell(cell: Image.Image, output_size: int, threshold: int) -> Image.Image:
    rgba = extract_alpha_sprite(cell, threshold)
    bbox = bbox_for_alpha(rgba)
    if bbox is None:
        return Image.new("RGBA", (output_size, output_size), (0, 0, 0, 0))

    cropped = rgba.crop(bbox)
    max_width = output_size - 16
    max_height = output_size - 16
    scale = min(max_width / cropped.width, max_height / cropped.height, 1.0)
    resized = cropped.resize((max(1, round(cropped.width * scale)), max(1, round(cropped.height * scale))), Image.Resampling.LANCZOS)

    normalized = Image.new("RGBA", (output_size, output_size), (0, 0, 0, 0))
    x = (output_size - resized.width) // 2
    y = output_size - resized.height - 10
    if resized.height > output_size - 20:
        y = (output_size - resized.height) // 2
    normalized.alpha_composite(resized, (x, y))
    return remove_visible_key_pixels(normalized, 44)


def write_outputs(args: argparse.Namespace) -> None:
    asset_dir = args.asset_dir
    normalized_dir = asset_dir / "normalized_128x128"
    normalized_dir.mkdir(parents=True, exist_ok=True)
    asset_dir.mkdir(parents=True, exist_ok=True)

    atlas = Image.new("RGBA", (args.columns * args.cell_size, args.rows * args.cell_size), (0, 0, 0, 0))
    raw_sheet = Image.new("RGBA", (args.columns * args.raw_cell_size, args.rows * args.raw_cell_size), KEY_RGB + (255,))
    proof_cell = 160
    proof = make_checker((args.columns * proof_cell, args.rows * proof_cell + 26))
    draw = ImageDraw.Draw(proof)
    font = ImageFont.load_default()

    items = []
    all_gate = True
    all_visible_key = 0
    for index, (item_id, display_name, logical_asset_id) in enumerate(ITEMS):
        column = index % args.columns
        row = index // args.columns
        if args.source_items_dir:
            source_path = args.source_items_dir / f"{item_id}_raw_chroma_ff00ff_v001.png"
            source_cell = Image.open(source_path).convert("RGBA")
        else:
            if not args.source:
                raise ValueError("--source or --source-items-dir is required")
            source = Image.open(args.source).convert("RGBA")
            source_width, source_height = source.size
            source_cell_width = source_width // args.columns
            source_cell_height = source_height // args.rows
            crop_box = (
                column * source_cell_width,
                row * source_cell_height,
                (column + 1) * source_cell_width if column < args.columns - 1 else source_width,
                (row + 1) * source_cell_height if row < args.rows - 1 else source_height,
            )
            source_cell = source.crop(crop_box)

        extracted = extract_alpha_sprite(source_cell, args.key_threshold)
        extracted_bbox = bbox_for_alpha(extracted)
        if extracted_bbox is not None:
            cropped_raw = extracted.crop(extracted_bbox)
            raw_max = args.raw_cell_size - 32
            raw_scale = min(raw_max / cropped_raw.width, raw_max / cropped_raw.height, 1.0)
            raw_resized = cropped_raw.resize((max(1, round(cropped_raw.width * raw_scale)), max(1, round(cropped_raw.height * raw_scale))), Image.Resampling.LANCZOS)
            raw_x = column * args.raw_cell_size + (args.raw_cell_size - raw_resized.width) // 2
            raw_y = row * args.raw_cell_size + (args.raw_cell_size - raw_resized.height) // 2
            raw_sheet.alpha_composite(raw_resized, (raw_x, raw_y))

        normalized = normalize_cell(source_cell, args.cell_size, args.key_threshold)
        normalized_path = normalized_dir / f"{item_id}_128x128.png"
        normalized.save(normalized_path)
        atlas.alpha_composite(normalized, (column * args.cell_size, row * args.cell_size))

        bbox = bbox_for_alpha(normalized)
        visible_key_pixels = count_visible_key_pixels(normalized, args.visible_key_threshold)
        all_visible_key += visible_key_pixels
        has_alpha = normalized.mode == "RGBA"
        fixed_cell = normalized.size == (args.cell_size, args.cell_size)
        has_bbox = bbox is not None and (bbox[2] - bbox[0]) >= 8 and (bbox[3] - bbox[1]) >= 8
        status = "pass" if fixed_cell and has_alpha and has_bbox and visible_key_pixels == 0 else "fail"
        all_gate = all_gate and status == "pass"

        proof_x = column * proof_cell
        proof_y = row * proof_cell
        proof.alpha_composite(normalized, (proof_x + 16, proof_y + 12))
        draw.rectangle((proof_x, proof_y, proof_x + proof_cell - 1, proof_y + proof_cell - 1), outline=(83, 68, 57, 255), width=1)
        draw.text((proof_x + 8, proof_y + proof_cell - 18), item_id, fill=(58, 50, 44, 255), font=font)

        bbox_list = list(bbox) if bbox is not None else []
        items.append({
            "index": index + 1,
            "id": item_id,
            "display_name": display_name,
            "logical_asset_id": logical_asset_id,
            "normalized_png": str(normalized_path),
            "atlas_cell": {"row": row, "column": column},
            "cell_size": [args.cell_size, args.cell_size],
            "pivot_px": [args.cell_size // 2, args.cell_size - 10],
            "bbox": bbox_list,
            "edge_touch_count": edge_touch_count(bbox, args.cell_size, args.cell_size) if bbox is not None else {},
            "component_count": count_components(normalized.getchannel("A")),
            "visible_key_pixel_count": visible_key_pixels,
            "has_alpha": has_alpha,
            "status": status,
        })

    atlas_path = asset_dir / "round173_furniture_128x128_atlas_v001.png"
    proof_path = asset_dir / "round173_furniture_128x128_proof_v001.png"
    manifest_path = asset_dir / "round173_furniture_manifest_v001.json"
    raw_sheet_path = args.docs_dir / "round173_furniture_raw_chroma_ff00ff_4x2_v002.png"
    args.docs_dir.mkdir(parents=True, exist_ok=True)
    raw_sheet.convert("RGB").save(raw_sheet_path)
    atlas.save(atlas_path)
    proof.save(proof_path)

    manifest = {
        "round": "Round173",
        "pack_id": "furniture",
        "status": "normalized_candidate",
        "runtime_boundary": "candidate_only_no_asset_resolver_or_themeprofile_mapping",
        "category": "furniture_prop",
        "source": str(raw_sheet_path),
        "raw_file": str(raw_sheet_path),
        "generated_item_sources_dir": str(args.source_items_dir) if args.source_items_dir else "",
        "atlas": str(atlas_path),
        "proof": str(proof_path),
        "normalized_dir": str(normalized_dir),
        "source_grid": {"columns": args.columns, "rows": args.rows},
        "cell_size": [args.cell_size, args.cell_size],
        "atlas_size": [atlas.width, atlas.height],
        "key_color": "#ff00ff",
        "gate_checks": {
            "fixed_cell": all(item["cell_size"] == [args.cell_size, args.cell_size] for item in items),
            "alpha": all(item["has_alpha"] for item in items),
            "bbox": all(bool(item["bbox"]) for item in items),
            "visible_key_pixels": all_visible_key,
            "visible_key_pixels_zero": all_visible_key == 0,
        },
        "overall_gate": "pass" if all_gate else "fail",
        "items": items,
    }
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({
        "manifest": str(manifest_path),
        "atlas": str(atlas_path),
        "proof": str(proof_path),
        "overall_gate": manifest["overall_gate"],
        "visible_key_pixels": all_visible_key,
        "item_count": len(items),
    }, ensure_ascii=False, indent=2))


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", type=Path)
    parser.add_argument("--source-items-dir", type=Path)
    parser.add_argument("--asset-dir", type=Path, default=Path("assets/art/visual_rebuild/round173/furniture"))
    parser.add_argument("--docs-dir", type=Path, default=Path("docs/collaboration/round173_visual_rebuild_asset_generation/furniture"))
    parser.add_argument("--columns", type=int, default=4)
    parser.add_argument("--rows", type=int, default=2)
    parser.add_argument("--cell-size", type=int, default=128)
    parser.add_argument("--raw-cell-size", type=int, default=256)
    parser.add_argument("--key-threshold", type=int, default=260)
    parser.add_argument("--visible-key-threshold", type=int, default=44)
    return parser.parse_args()


if __name__ == "__main__":
    write_outputs(parse_args())
