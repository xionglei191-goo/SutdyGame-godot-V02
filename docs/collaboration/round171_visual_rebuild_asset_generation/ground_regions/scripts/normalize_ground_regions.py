#!/usr/bin/env python3
import json
import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[5]
WORK_DIR = ROOT / "docs/collaboration/round171_visual_rebuild_asset_generation/ground_regions"
ASSET_DIR = ROOT / "assets/art/visual_rebuild/round171/ground_regions"
KEY = (255, 0, 255)
KEY_HEX = "#ff00ff"
VERSION = "v002"


SETS = [
    {
        "name": "meadow_chunks",
        "category": "ground_meadow_region",
        "raw": WORK_DIR / "raw/round171_ground_meadow_chunks_raw_sheet_v001.png",
        "asset_atlas": ASSET_DIR / f"ground_meadow_chunks_256x256_atlas_{VERSION}.png",
        "asset_proof": ASSET_DIR / f"ground_meadow_chunks_256x256_tile_proof_{VERSION}.png",
        "manifest": ASSET_DIR / f"ground_meadow_chunks_256x256_manifest_{VERSION}.json",
        "cell": (256, 256),
        "source_grid": (2, 2),
        "ids": [
            "ground_region.meadow_chunk.01",
            "ground_region.meadow_chunk.02",
            "ground_region.meadow_chunk.03",
            "ground_region.meadow_chunk.04",
        ],
        "fit": "contain",
    },
    {
        "name": "soft_path_bands",
        "category": "ground_soft_path_band",
        "raw": WORK_DIR / "raw/round171_ground_soft_path_bands_raw_sheet_v001.png",
        "asset_atlas": ASSET_DIR / f"ground_soft_path_bands_512x256_atlas_{VERSION}.png",
        "asset_proof": ASSET_DIR / f"ground_soft_path_bands_512x256_tile_proof_{VERSION}.png",
        "manifest": ASSET_DIR / f"ground_soft_path_bands_512x256_manifest_{VERSION}.json",
        "cell": (512, 256),
        "source_grid": (2, 2),
        "ids": [
            "ground_region.soft_path_band.01",
            "ground_region.soft_path_band.02",
            "ground_region.soft_path_band.03",
            "ground_region.soft_path_band.04",
        ],
        "fit": "contain",
    },
    {
        "name": "grass_path_edges",
        "category": "ground_grass_path_edge",
        "raw": WORK_DIR / "raw/round171_ground_grass_path_edges_raw_sheet_v001.png",
        "asset_atlas": ASSET_DIR / f"ground_grass_path_edges_256x256_atlas_{VERSION}.png",
        "asset_proof": ASSET_DIR / f"ground_grass_path_edges_256x256_tile_proof_{VERSION}.png",
        "manifest": ASSET_DIR / f"ground_grass_path_edges_256x256_manifest_{VERSION}.json",
        "cell": (256, 256),
        "source_grid": (2, 2),
        "ids": [
            "ground_region.grass_path_edge.01",
            "ground_region.grass_path_edge.02",
            "ground_region.grass_path_edge.03",
            "ground_region.grass_path_edge.04",
        ],
        "fit": "contain",
    },
]


def color_distance(rgb, key):
    return math.sqrt(sum((int(rgb[i]) - key[i]) ** 2 for i in range(3)))


def chroma_to_alpha(image, threshold=70, feather=145):
    rgba = image.convert("RGBA")
    pixels = rgba.load()
    width, height = rgba.size
    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            dist = color_distance((r, g, b), KEY)
            if dist <= threshold:
                pixels[x, y] = (r, g, b, 0)
            elif dist <= feather:
                alpha = int(255 * ((dist - threshold) / max(1, feather - threshold)))
                pixels[x, y] = (r, g, b, min(a, alpha))
    return rgba


def alpha_bbox(image):
    alpha = image.getchannel("A")
    return alpha.getbbox()


def count_visible_key_pixels(image):
    rgba = image.convert("RGBA")
    count = 0
    data = rgba.get_flattened_data() if hasattr(rgba, "get_flattened_data") else rgba.getdata()
    for r, g, b, a in data:
        if a > 0 and abs(r - KEY[0]) <= 8 and abs(g - KEY[1]) <= 8 and abs(b - KEY[2]) <= 8:
            count += 1
    return count


def is_magenta_fringe_pixel(r, g, b, a):
    if a == 0:
        return False
    return r >= 145 and b >= 145 and g <= 165 and (r - g) > 24 and (b - g) > 20


def is_suspicious_edge_color(r, g, b, a):
    if a == 0:
        return False
    if is_magenta_fringe_pixel(r, g, b, a):
        return True
    if r >= 112 and b >= 112 and g <= 190 and max(r, b) >= g - 18:
        return True
    if b >= 120 and b >= g - 12 and r >= g - 30:
        return True
    return False


def count_magenta_fringe_pixels(image):
    rgba = image.convert("RGBA")
    count = 0
    data = rgba.get_flattened_data() if hasattr(rgba, "get_flattened_data") else rgba.getdata()
    for r, g, b, a in data:
        if is_magenta_fringe_pixel(r, g, b, a):
            count += 1
    return count


def has_transparent_neighbor(pixels, x, y, width, height, radius=2):
    for ny in range(max(0, y - radius), min(height, y + radius + 1)):
        for nx in range(max(0, x - radius), min(width, x + radius + 1)):
            if nx == x and ny == y:
                continue
            if pixels[nx, ny][3] == 0:
                return True
    return False


def count_suspicious_edge_pixels(image):
    rgba = image.convert("RGBA")
    pixels = rgba.load()
    width, height = rgba.size
    count = 0
    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            if is_suspicious_edge_color(r, g, b, a) and has_transparent_neighbor(pixels, x, y, width, height):
                count += 1
    return count


def sample_nearby_clean_color(pixels, x, y, width, height):
    samples = []
    for radius in range(1, 5):
        for ny in range(max(0, y - radius), min(height, y + radius + 1)):
            for nx in range(max(0, x - radius), min(width, x + radius + 1)):
                r, g, b, a = pixels[nx, ny]
                if a >= 180 and not is_suspicious_edge_color(r, g, b, a):
                    samples.append((r, g, b))
        if samples:
            break
    if not samples:
        return None
    return tuple(int(sum(color[i] for color in samples) / len(samples)) for i in range(3))


def remove_key_fringe(image):
    rgba = image.convert("RGBA")
    pixels = rgba.load()
    width, height = rgba.size
    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            if a == 0:
                continue
            dist = color_distance((r, g, b), KEY)
            if dist <= 95:
                pixels[x, y] = (r, g, b, 0)
            elif is_magenta_fringe_pixel(r, g, b, a):
                if a < 80:
                    pixels[x, y] = (r, g, b, 0)
                else:
                    despilled_g = max(g, min(190, g + 44))
                    pixels[x, y] = (
                        min(r, max(112, despilled_g + 12)),
                        despilled_g,
                        min(b, max(112, despilled_g + 8)),
                        a,
                    )
    return rgba


def repair_suspicious_alpha_edges(image):
    rgba = image.convert("RGBA")
    pixels = rgba.load()
    width, height = rgba.size
    edits = []
    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            if not is_suspicious_edge_color(r, g, b, a):
                continue
            if not has_transparent_neighbor(pixels, x, y, width, height):
                continue
            if a < 190:
                edits.append((x, y, (r, g, b, 0)))
                continue
            clean_color = sample_nearby_clean_color(pixels, x, y, width, height)
            if clean_color == None:
                edits.append((x, y, (r, g, b, 0)))
            else:
                edits.append((x, y, (clean_color[0], clean_color[1], clean_color[2], a)))
    for x, y, value in edits:
        pixels[x, y] = value
    return rgba


def drop_remaining_suspicious_alpha_edges(image):
    rgba = image.convert("RGBA")
    for _pass_index in range(32):
        pixels = rgba.load()
        width, height = rgba.size
        edits = []
        for y in range(height):
            for x in range(width):
                r, g, b, a = pixels[x, y]
                if is_suspicious_edge_color(r, g, b, a) and has_transparent_neighbor(pixels, x, y, width, height):
                    edits.append((x, y, (r, g, b, 0)))
        if not edits:
            break
        for x, y, value in edits:
            pixels[x, y] = value
    return rgba


def edge_alpha_touch_count(image):
    alpha = image.getchannel("A")
    width, height = alpha.size
    px = alpha.load()
    return {
        "top": sum(1 for x in range(width) if px[x, 0] > 0),
        "right": sum(1 for y in range(height) if px[width - 1, y] > 0),
        "bottom": sum(1 for x in range(width) if px[x, height - 1] > 0),
        "left": sum(1 for y in range(height) if px[0, y] > 0),
    }


def connected_components(image):
    alpha = image.getchannel("A")
    width, height = alpha.size
    px = alpha.load()
    seen = set()
    components = 0
    for y in range(height):
        for x in range(width):
            if px[x, y] == 0 or (x, y) in seen:
                continue
            components += 1
            stack = [(x, y)]
            seen.add((x, y))
            while stack:
                cx, cy = stack.pop()
                for nx, ny in ((cx + 1, cy), (cx - 1, cy), (cx, cy + 1), (cx, cy - 1)):
                    if 0 <= nx < width and 0 <= ny < height and px[nx, ny] > 0 and (nx, ny) not in seen:
                        seen.add((nx, ny))
                        stack.append((nx, ny))
    return components


def normalize_cell(source_cell, out_size):
    keyed = chroma_to_alpha(source_cell)
    bbox = alpha_bbox(keyed)
    result = Image.new("RGBA", out_size, (0, 0, 0, 0))
    if not bbox:
        return result
    crop = keyed.crop(bbox)
    margin = 8
    max_w = out_size[0] - margin * 2
    max_h = out_size[1] - margin * 2
    scale = min(max_w / crop.width, max_h / crop.height)
    new_size = (max(1, int(crop.width * scale)), max(1, int(crop.height * scale)))
    crop = crop.resize(new_size, Image.Resampling.LANCZOS)
    pos = ((out_size[0] - new_size[0]) // 2, (out_size[1] - new_size[1]) // 2)
    result.alpha_composite(crop, pos)
    result = remove_key_fringe(result)
    result = repair_suspicious_alpha_edges(result)
    result = repair_suspicious_alpha_edges(result)
    return drop_remaining_suspicious_alpha_edges(result)


def draw_proof(atlas, items, cell_size, out_path):
    cols = 2
    rows = math.ceil(len(items) / cols)
    label_h = 34
    proof = Image.new("RGBA", (cols * cell_size[0], rows * (cell_size[1] + label_h)), (30, 36, 38, 255))
    draw = ImageDraw.Draw(proof)
    try:
        font = ImageFont.truetype("DejaVuSans.ttf", 12)
    except OSError:
        font = ImageFont.load_default()
    for i, item in enumerate(items):
        col = i % cols
        row = i // cols
        x = col * cell_size[0]
        y = row * (cell_size[1] + label_h)
        cell = atlas.crop((col * cell_size[0], row * cell_size[1], (col + 1) * cell_size[0], (row + 1) * cell_size[1]))
        checker = Image.new("RGBA", cell_size, (220, 225, 216, 255))
        checker_draw = ImageDraw.Draw(checker)
        step = 16
        for cy in range(0, cell_size[1], step):
            for cx in range(0, cell_size[0], step):
                if ((cx // step) + (cy // step)) % 2:
                    checker_draw.rectangle((cx, cy, cx + step - 1, cy + step - 1), fill=(186, 197, 186, 255))
        checker.alpha_composite(cell)
        proof.alpha_composite(checker, (x, y))
        draw.rectangle((x, y, x + cell_size[0] - 1, y + cell_size[1] - 1), outline=(255, 255, 255, 210), width=1)
        draw.text((x + 8, y + cell_size[1] + 6), f"{item['id']}  {item['status']}", fill=(245, 248, 241, 255), font=font)
        bbox = item["placed_bbox"]
        if bbox:
            draw.rectangle((x + bbox[0], y + bbox[1], x + bbox[2], y + bbox[3]), outline=(255, 214, 91, 230), width=1)
    proof.save(out_path)


def normalize_set(spec):
    if not spec["raw"].exists():
        raise FileNotFoundError(spec["raw"])
    raw = Image.open(spec["raw"]).convert("RGB")
    cols, rows = spec["source_grid"]
    src_w = raw.width // cols
    src_h = raw.height // rows
    out_w, out_h = spec["cell"]
    atlas = Image.new("RGBA", (cols * out_w, rows * out_h), (0, 0, 0, 0))
    items = []
    for index, asset_id in enumerate(spec["ids"]):
        col = index % cols
        row = index // cols
        source_cell = raw.crop((col * src_w, row * src_h, (col + 1) * src_w, (row + 1) * src_h))
        normalized = normalize_cell(source_cell, spec["cell"])
        atlas.alpha_composite(normalized, (col * out_w, row * out_h))
        bbox = alpha_bbox(normalized)
        item = {
            "index": index + 1,
            "id": asset_id,
            "source_cell": {"row": row, "column": col, "size": [src_w, src_h]},
            "cell_size": [out_w, out_h],
            "placed_bbox": list(bbox) if bbox else None,
            "edge_alpha_touch_count": edge_alpha_touch_count(normalized),
            "components": connected_components(normalized),
            "visible_key_pixel_count": count_visible_key_pixels(normalized),
            "magenta_fringe_pixel_count": count_magenta_fringe_pixels(normalized),
            "suspicious_edge_pixel_count": count_suspicious_edge_pixels(normalized),
        }
        item["status"] = "pass" if bbox and item["visible_key_pixel_count"] == 0 and item["magenta_fringe_pixel_count"] == 0 and item["suspicious_edge_pixel_count"] == 0 else "fail"
        items.append(item)
    spec["asset_atlas"].parent.mkdir(parents=True, exist_ok=True)
    atlas.save(spec["asset_atlas"])
    draw_proof(atlas, items, spec["cell"], spec["asset_proof"])
    manifest = {
        "status": "normalized_candidate",
        "runtime_boundary": "proof_only_not_mapped_to_asset_resolver_or_theme_profile",
        "category": spec["category"],
        "source": str(spec["raw"].relative_to(ROOT)),
        "atlas": str(spec["asset_atlas"].relative_to(ROOT)),
        "tile_proof": str(spec["asset_proof"].relative_to(ROOT)),
        "source_grid": {"columns": cols, "rows": rows},
        "source_cell_size": [src_w, src_h],
        "cell_size": [out_w, out_h],
        "key_color": KEY_HEX,
        "normalization": "source quadrant chroma-keyed to transparent RGBA, alpha bbox contained into fixed output cell with 8px margin, post-resize magenta despill and alpha-edge color repair applied",
        "residue_gate": "visible_key_pixel_count == 0, magenta_fringe_pixel_count == 0, and suspicious_edge_pixel_count == 0 for every item",
        "recommended_use": "visual layout proof overlays for larger meadow/path regions to reduce visible 64px grid rhythm",
        "items": items,
        "overall_gate": "pass" if all(item["status"] == "pass" for item in items) else "fail",
    }
    spec["manifest"].write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    return manifest


def main():
    summary = []
    for spec in SETS:
        summary.append(normalize_set(spec))
    report = WORK_DIR / f"normalized/round171_ground_regions_normalization_summary_{VERSION}.json"
    report.parent.mkdir(parents=True, exist_ok=True)
    report.write_text(json.dumps(summary, indent=2), encoding="utf-8")
    print(json.dumps({"sets": len(summary), "overall": [m["overall_gate"] for m in summary]}, indent=2))


if __name__ == "__main__":
    main()
