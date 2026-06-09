#!/usr/bin/env python3
"""Round170 fence-only chroma normalization helper.

This is a proof-local script kept inside the worker-owned collaboration folder.
It does not wire assets into runtime mappings.
"""

from __future__ import annotations

import argparse
import json
from collections import deque
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


def parse_hex_color(value: str) -> tuple[int, int, int]:
    text = value.strip().lstrip("#")
    if len(text) != 6:
        raise argparse.ArgumentTypeError("hex color must be RRGGBB")
    return int(text[0:2], 16), int(text[2:4], 16), int(text[4:6], 16)


def is_key_like(pixel: tuple[int, int, int, int], key: tuple[int, int, int], tolerance: int) -> bool:
    red, green, blue, _alpha = pixel
    return abs(red - key[0]) + abs(green - key[1]) + abs(blue - key[2]) <= tolerance


def remove_edge_connected_key(cell: Image.Image, key: tuple[int, int, int], tolerance: int) -> Image.Image:
    width, height = cell.size
    pixels = cell.load()
    seen = [bytearray(width) for _ in range(height)]
    queue: deque[tuple[int, int]] = deque()

    def enqueue(x: int, y: int) -> None:
        if seen[y][x] or not is_key_like(pixels[x, y], key, tolerance):
            return
        seen[y][x] = 1
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

    out = Image.new("RGBA", cell.size, (0, 0, 0, 0))
    out_pixels = out.load()
    for y in range(height):
        for x in range(width):
            if seen[y][x]:
                out_pixels[x, y] = (0, 0, 0, 0)
            else:
                out_pixels[x, y] = pixels[x, y]
    return out


def clear_key_pixels(image: Image.Image, key: tuple[int, int, int], tolerance: int) -> int:
    pixels = image.load()
    width, height = image.size
    cleared = 0
    for y in range(height):
        for x in range(width):
            red, green, blue, alpha = pixels[x, y]
            if alpha > 0 and is_key_like((red, green, blue, alpha), key, tolerance):
                pixels[x, y] = (0, 0, 0, 0)
                cleared += 1
    return cleared


def count_visible_key(image: Image.Image, key: tuple[int, int, int], tolerance: int) -> int:
    pixels = image.load()
    width, height = image.size
    count = 0
    for y in range(height):
        for x in range(width):
            red, green, blue, alpha = pixels[x, y]
            if alpha > 0 and is_key_like((red, green, blue, alpha), key, tolerance):
                count += 1
    return count


def edge_touch(alpha: Image.Image) -> dict[str, int]:
    width, height = alpha.size
    pixels = alpha.load()
    return {
        "top": sum(1 for x in range(width) if pixels[x, 0] > 0),
        "bottom": sum(1 for x in range(width) if pixels[x, height - 1] > 0),
        "left": sum(1 for y in range(height) if pixels[0, y] > 0),
        "right": sum(1 for y in range(height) if pixels[width - 1, y] > 0),
    }


def component_count(alpha: Image.Image, threshold: int, min_area: int) -> int:
    width, height = alpha.size
    pixels = alpha.load()
    seen = [bytearray(width) for _ in range(height)]
    count = 0
    for start_y in range(height):
        for start_x in range(width):
            if seen[start_y][start_x] or pixels[start_x, start_y] < threshold:
                continue
            area = 0
            queue: deque[tuple[int, int]] = deque([(start_x, start_y)])
            seen[start_y][start_x] = 1
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


def load_font(size: int) -> ImageFont.ImageFont | ImageFont.FreeTypeFont:
    font_path = Path("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf")
    if font_path.exists():
        return ImageFont.truetype(str(font_path), size)
    return ImageFont.load_default()


def save_pivot_proof(atlas: Image.Image, path: Path, columns: int, rows: int, cell: int, pivot_y: int) -> None:
    proof = Image.new("RGBA", atlas.size, (238, 238, 232, 255))
    draw = ImageDraw.Draw(proof)
    for y in range(0, proof.height, 8):
        for x in range(0, proof.width, 8):
            if (x // 8 + y // 8) % 2:
                draw.rectangle([x, y, x + 7, y + 7], fill=(224, 224, 218, 255))
    proof.alpha_composite(atlas)
    draw = ImageDraw.Draw(proof)
    font = load_font(9)
    for row in range(rows):
        for column in range(columns):
            x0 = column * cell
            y0 = row * cell
            x1 = x0 + cell - 1
            y1 = y0 + cell - 1
            px = x0 + cell // 2
            py = y0 + pivot_y
            draw.rectangle([x0, y0, x1, y1], outline=(52, 84, 120, 255), width=1)
            draw.line([x0, py, x1, py], fill=(220, 80, 70, 220), width=1)
            draw.line([px - 4, py, px + 4, py], fill=(20, 20, 20, 255), width=1)
            draw.line([px, py - 4, px, py + 4], fill=(20, 20, 20, 255), width=1)
            draw.text((x0 + 3, y0 + 3), str(row * columns + column + 1), fill=(20, 20, 20, 255), font=font)
    proof.save(path)


def normalize(args: argparse.Namespace) -> dict:
    source = args.source
    output_dir = args.output_dir
    output_dir.mkdir(parents=True, exist_ok=True)
    individual_dir = output_dir / f"normalized_{args.cell_size}x{args.cell_size}"
    individual_dir.mkdir(parents=True, exist_ok=True)

    key = parse_hex_color(args.key_color)
    image = Image.open(source).convert("RGBA")
    source_cell_width = image.width // args.columns
    source_cell_height = image.height // args.rows
    alpha_source = Image.new("RGBA", image.size, (0, 0, 0, 0))
    atlas = Image.new("RGBA", (args.columns * args.cell_size, args.rows * args.cell_size), (0, 0, 0, 0))
    items = []

    for row in range(args.rows):
        for column in range(args.columns):
            index = row * args.columns + column + 1
            x0 = column * source_cell_width
            y0 = row * source_cell_height
            x1 = image.width if column == args.columns - 1 else (column + 1) * source_cell_width
            y1 = image.height if row == args.rows - 1 else (row + 1) * source_cell_height
            clean_cell = remove_edge_connected_key(image.crop((x0, y0, x1, y1)), key, args.tolerance)
            alpha_source.alpha_composite(clean_cell, (x0, y0))
            bbox = clean_cell.getchannel("A").getbbox()
            if bbox is None:
                items.append({"index": index, "status": "empty"})
                continue

            subject = clean_cell.crop(bbox)
            scale = min(args.fit_width / subject.width, args.fit_height / subject.height, 1.0)
            target_width = max(1, round(subject.width * scale))
            target_height = max(1, round(subject.height * scale))
            subject = subject.resize((target_width, target_height), Image.Resampling.LANCZOS)
            canvas = Image.new("RGBA", (args.cell_size, args.cell_size), (0, 0, 0, 0))
            origin_x = args.cell_size // 2 - target_width // 2
            origin_y = args.pivot_y - target_height
            canvas.alpha_composite(subject, (origin_x, origin_y))
            cleared_key = clear_key_pixels(canvas, key, args.tolerance)

            item_path = individual_dir / f"fence_segment_{index:02d}_{args.cell_size}x{args.cell_size}.png"
            canvas.save(item_path)
            atlas.alpha_composite(canvas, (column * args.cell_size, row * args.cell_size))

            alpha = canvas.getchannel("A")
            placed_bbox = alpha.getbbox()
            left, top, right, bottom = placed_bbox
            margins = {
                "left": left,
                "top": top,
                "right": args.cell_size - right,
                "bottom": args.cell_size - bottom,
            }
            edges = edge_touch(alpha)
            components = component_count(alpha, args.component_threshold, args.component_min_area)
            visible_key = count_visible_key(canvas, key, args.tolerance)
            gate_pass = (
                all(value == 0 for value in edges.values())
                and 1 <= components <= args.max_components
                and visible_key == 0
                and margins["left"] >= args.min_margin
                and margins["right"] >= args.min_margin
                and margins["top"] >= args.min_margin
                and margins["bottom"] >= args.min_bottom_margin
            )
            items.append({
                "index": index,
                "id": f"fence_segment.{index:02d}",
                "source_cell": {"row": row, "column": column},
                "source_bbox_in_cell": list(bbox),
                "normalized_png": str(item_path),
                "cell_size": [args.cell_size, args.cell_size],
                "fit_box": [args.fit_width, args.fit_height],
                "pivot_px": [args.cell_size // 2, args.pivot_y],
                "placed_bbox": list(placed_bbox),
                "margins_px": margins,
                "edge_touch_count": edges,
                "components": components,
                "max_components": args.max_components,
                "visible_key_pixel_count": visible_key,
                "cleared_key_pixel_count_after_resize": cleared_key,
                "scale_from_source_crop": scale,
                "status": "pass" if gate_pass else "needs_review",
            })

    alpha_source_path = output_dir / f"{source.stem}_chroma_alpha.png"
    atlas_path = output_dir / f"{source.stem}_{args.cell_size}x{args.cell_size}_atlas.png"
    proof_path = output_dir / f"{source.stem}_{args.cell_size}x{args.cell_size}_pivot_proof.png"
    manifest_path = output_dir / f"{source.stem}_{args.cell_size}x{args.cell_size}_manifest.json"
    alpha_source.save(alpha_source_path)
    atlas.save(atlas_path)
    save_pivot_proof(atlas, proof_path, args.columns, args.rows, args.cell_size, args.pivot_y)
    manifest = {
        "source": str(source),
        "alpha_source": str(alpha_source_path),
        "atlas": str(atlas_path),
        "pivot_proof": str(proof_path),
        "source_grid": {"columns": args.columns, "rows": args.rows},
        "cell_size": [args.cell_size, args.cell_size],
        "fit_box": [args.fit_width, args.fit_height],
        "pivot_px": [args.cell_size // 2, args.pivot_y],
        "key_color": f"#{args.key_color.strip().lstrip('#')}",
        "items": items,
        "overall_gate": "pass" if all(item.get("status") == "pass" for item in items) else "needs_review",
    }
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return manifest


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--columns", type=int, default=3)
    parser.add_argument("--rows", type=int, default=2)
    parser.add_argument("--key-color", default="00ffff")
    parser.add_argument("--tolerance", type=int, default=30)
    parser.add_argument("--cell-size", type=int, default=64)
    parser.add_argument("--fit-width", type=int, default=56)
    parser.add_argument("--fit-height", type=int, default=46)
    parser.add_argument("--pivot-y", type=int, default=58)
    parser.add_argument("--min-margin", type=int, default=2)
    parser.add_argument("--min-bottom-margin", type=int, default=2)
    parser.add_argument("--component-threshold", type=int, default=48)
    parser.add_argument("--component-min-area", type=int, default=6)
    parser.add_argument("--max-components", type=int, default=4)
    args = parser.parse_args()
    manifest = normalize(args)
    print(json.dumps({
        "atlas": manifest["atlas"],
        "pivot_proof": manifest["pivot_proof"],
        "overall_gate": manifest["overall_gate"],
        "item_status": [item.get("status") for item in manifest["items"]],
    }, indent=2))


if __name__ == "__main__":
    main()
