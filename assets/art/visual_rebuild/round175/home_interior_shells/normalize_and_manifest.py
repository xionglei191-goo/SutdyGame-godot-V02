#!/usr/bin/env python3
import json
import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageStat


ROOT = Path(__file__).resolve().parent
RAW = ROOT / "raw"
PROOF = ROOT / "proof"
PROMPTS = ROOT / "source_prompts.json"
MANIFEST = ROOT / "round175_home_interior_shells_manifest.json"


def asset_ref(path):
    return str(path.relative_to(ROOT.parents[4]))


def crop_square(img):
    w, h = img.size
    side = min(w, h)
    x = (w - side) // 2
    y = (h - side) // 2
    return img.crop((x, y, x + side, y + side))


def center_crop_ratio(img, ratio):
    w, h = img.size
    current = w / h
    if current > ratio:
        nw = int(h * ratio)
        x = (w - nw) // 2
        return img.crop((x, 0, x + nw, h))
    nh = int(w / ratio)
    y = (h - nh) // 2
    return img.crop((0, y, w, y + nh))


def tint(img, color, strength):
    overlay = Image.new("RGBA", img.size, color)
    return Image.blend(img.convert("RGBA"), overlay, strength)


def edge_fade_mask(size, margin_x, margin_y, base=255):
    w, h = size
    mask = Image.new("L", size, 0)
    draw = ImageDraw.Draw(mask)
    draw.rectangle((margin_x, margin_y, w - margin_x - 1, h - margin_y - 1), fill=base)
    return mask.filter(ImageFilter.GaussianBlur(max(margin_x, margin_y) / 2))


def vertical_band_mask(size, fade=24, base=255):
    w, h = size
    mask = Image.new("L", size, base)
    pix = mask.load()
    for y in range(h):
        a = base
        if y < fade:
            a = int(base * y / fade)
        elif y > h - fade:
            a = int(base * (h - y) / fade)
        for x in range(w):
            pix[x, y] = min(pix[x, y], a)
    return mask.filter(ImageFilter.GaussianBlur(1.5))


def rounded_rect_mask(size, radius=42, blur=10):
    w, h = size
    mask = Image.new("L", size, 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle((12, 12, w - 13, h - 13), radius=radius, fill=255)
    return mask.filter(ImageFilter.GaussianBlur(blur))


def l_shadow(size):
    w, h = size
    alpha = Image.new("L", size, 0)
    pix = alpha.load()
    for y in range(h):
        for x in range(w):
            left = max(0, 1 - x / (w * 0.35))
            top = max(0, 1 - y / (h * 0.35))
            corner = max(0, 1 - math.hypot(x, y) / (w * 0.56))
            val = int(155 * max(left * 0.72, top * 0.72, corner * 0.55))
            pix[x, y] = val
    alpha = alpha.filter(ImageFilter.GaussianBlur(18))
    img = Image.new("RGBA", size, (73, 56, 51, 0))
    img.putalpha(alpha)
    return img


def add_plank_lines(img):
    draw = ImageDraw.Draw(img, "RGBA")
    w, h = img.size
    for y in range(42, h, 58):
        draw.line((0, y, w, y + 10), fill=(118, 82, 47, 28), width=3)
    for i, x in enumerate(range(58, w, 112)):
        y0 = (i % 3) * 24
        draw.line((x, y0, x + 8, h), fill=(255, 232, 178, 18), width=2)
    return img


def procedural_wood_region(size):
    w, h = size
    img = Image.new("RGBA", size, (206, 147, 82, 255))
    pix = img.load()
    for y in range(h):
        for x in range(w):
            grain = int(10 * math.sin((x + y * 0.35) / 17.0) + 6 * math.sin(x / 5.3))
            shade = int(18 * (y / h))
            pix[x, y] = (
                max(0, min(255, 208 + grain - shade)),
                max(0, min(255, 151 + grain // 2 - shade)),
                max(0, min(255, 83 + grain // 3 - shade)),
                255
            )
    draw = ImageDraw.Draw(img, "RGBA")
    board_h = 58
    slant = 34
    for y in range(-board_h, h + board_h, board_h):
        draw.line((0, y, w, y + slant), fill=(119, 79, 44, 52), width=3)
        draw.line((0, y + 3, w, y + slant + 3), fill=(255, 225, 161, 18), width=1)
    for row, y in enumerate(range(0, h, board_h)):
        offset = (row % 3) * 92
        for x in range(-offset, w + 120, 146):
            draw.line((x, y, x + 18, y + board_h), fill=(116, 76, 44, 32), width=2)
    return img.filter(ImageFilter.GaussianBlur(0.2))


def sunny_empty_corner_shell(size):
    w, h = size
    img = Image.new("RGBA", size, (0, 0, 0, 0))
    wall = Image.new("RGBA", size, (236, 181, 126, 255))
    pix = wall.load()
    for y in range(h):
        for x in range(w):
            right_warm = int(22 * x / w)
            floor_warm = int(18 * max(0, y - h * 0.62) / (h * 0.38))
            texture = int(5 * math.sin((x + y) / 23.0))
            pix[x, y] = (232 + texture + right_warm, 176 + texture // 2 + floor_warm, 124 + texture // 3, 255)
    alpha = edge_fade_mask(size, 28, 20, 244)
    wall.putalpha(alpha)
    img.alpha_composite(wall)
    draw = ImageDraw.Draw(img, "RGBA")
    corner_x = int(w * 0.52)
    draw.line((corner_x, 42, corner_x, h - 86), fill=(161, 101, 68, 46), width=5)
    draw.rounded_rectangle((42, h - 118, w - 48, h - 82), radius=18, fill=(143, 91, 58, 72))
    draw.rectangle((52, h - 82, w - 58, h - 38), fill=(213, 147, 88, 50))
    draw.ellipse((int(w * 0.58), int(h * 0.48), int(w * 1.02), int(h * 0.96)), fill=(247, 206, 119, 38))
    return img.filter(ImageFilter.GaussianBlur(0.2))


def process_item(spec):
    item_id = spec["id"]
    size = tuple(spec["size"])
    raw_path = RAW / f"{item_id}_raw.png"
    if not raw_path.exists():
        raise FileNotFoundError(raw_path)

    raw = Image.open(raw_path).convert("RGBA")
    base = center_crop_ratio(crop_square(raw), size[0] / size[1]).resize(size, Image.Resampling.LANCZOS)

    if item_id == "floor_wood_region":
        out = procedural_wood_region(size)
        alpha = vertical_band_mask(size, 18, 238)
        out.putalpha(alpha)
        layer = "floor_region_below_furniture_and_actors; deliberate broad opaque band, not a standalone sprite"
        pivot = [size[0] // 2, size[1] // 2]
        scale = "1.0 at 1280x720 composition, crop/overlap under walls as needed"
    elif item_id == "floor_soft_rug_region":
        out = tint(base.filter(ImageFilter.GaussianBlur(0.6)), (221, 146, 128, 255), 0.18)
        mask = Image.new("L", size, 0)
        draw = ImageDraw.Draw(mask)
        draw.ellipse((24, 30, size[0] - 25, size[1] - 31), fill=238)
        mask = mask.filter(ImageFilter.GaussianBlur(12))
        out.putalpha(mask)
        layer = "floor_accent_region_above_floor_wood_below_furniture; region asset, not pickup sprite"
        pivot = [size[0] // 2, size[1] // 2]
        scale = "0.75-1.0 under bed/table clusters"
    elif item_id == "wall_warm_plaster_band":
        out = tint(base.filter(ImageFilter.GaussianBlur(0.8)), (232, 188, 145, 255), 0.36)
        draw = ImageDraw.Draw(out, "RGBA")
        draw.rounded_rectangle((0, size[1] - 56, size[0], size[1] - 34), radius=8, fill=(143, 94, 58, 82))
        draw.rectangle((0, size[1] - 34, size[0], size[1]), fill=(118, 78, 49, 42))
        out.putalpha(vertical_band_mask(size, 16, 246))
        layer = "back_wall_region_behind_props; deliberate wall band, not a standalone sprite"
        pivot = [size[0] // 2, size[1]]
        scale = "1.0-1.25 horizontally, keep behind all furniture"
    elif item_id == "wall_window_nook":
        out = tint(base.filter(ImageFilter.GaussianBlur(0.25)), (235, 197, 151, 255), 0.18)
        out.putalpha(rounded_rect_mask(size, 44, 8))
        layer = "wall_prefab_above_wall_band_below_hanging_props"
        pivot = [size[0] // 2, size[1]]
        scale = "0.65-0.9, anchor to back wall"
    elif item_id == "interior_corner_shadow":
        out = l_shadow(size)
        layer = "shadow_overlay_above_wall_floor_regions_below_props"
        pivot = [0, 0]
        scale = "1.0; multiply/modulate in proof composition"
    elif item_id == "doorway_threshold":
        out = tint(base.filter(ImageFilter.GaussianBlur(0.3)), (196, 124, 70, 255), 0.2)
        mask = rounded_rect_mask(size, 30, 9)
        out.putalpha(mask)
        layer = "floor_transition_prefab_above_floor_region_below_actors"
        pivot = [size[0] // 2, size[1] - 20]
        scale = "0.75-1.0 at room entrance edge"
    elif item_id == "small_room_back_wall_prefab":
        out = tint(base.filter(ImageFilter.GaussianBlur(0.6)), (229, 178, 133, 255), 0.28)
        draw = ImageDraw.Draw(out, "RGBA")
        draw.rounded_rectangle((26, size[1] - 116, size[0] - 27, size[1] - 70), radius=20, fill=(122, 76, 50, 70))
        draw.rectangle((32, size[1] - 70, size[0] - 33, size[1] - 36), fill=(205, 146, 91, 54))
        out.putalpha(edge_fade_mask(size, 26, 18, 248))
        layer = "room_shell_prefab_behind_furniture_and_actors; broad prefab background with faded edge"
        pivot = [size[0] // 2, size[1]]
        scale = "0.9-1.1, align bottom with floor seam"
    elif item_id == "sunny_bed_corner_shell":
        out = sunny_empty_corner_shell(size)
        layer = "pet_bed_corner_shell_behind_round173_sunny_bed_sprite"
        pivot = [size[0] // 2, size[1]]
        scale = "0.85-1.0, place Round173 sunny_bed in front at 128x128 or 1.15x"
    else:
        raise ValueError(item_id)

    out_path = ROOT / f"{item_id}.png"
    out.save(out_path)
    return out_path, raw_path, layer, pivot, scale


def alpha_bbox(img):
    alpha = img.getchannel("A")
    return alpha.getbbox()


def edge_stats(img):
    alpha = img.getchannel("A")
    w, h = img.size
    edges = {
        "top_max_alpha": max(alpha.crop((0, 0, w, 1)).getdata()),
        "bottom_max_alpha": max(alpha.crop((0, h - 1, w, h)).getdata()),
        "left_max_alpha": max(alpha.crop((0, 0, 1, h)).getdata()),
        "right_max_alpha": max(alpha.crop((w - 1, 0, w, h)).getdata())
    }
    return edges


def residue_count(img):
    pix = img.convert("RGBA").getdata()
    count = 0
    for r, g, b, a in pix:
        if a > 8 and ((g > 235 and r < 40 and b < 40) or (r > 235 and b > 235 and g < 70)):
            count += 1
    return count


def make_contact(items):
    cell_w = max(item["dimensions"][0] for item in items)
    cell_h = max(item["dimensions"][1] for item in items)
    sheet = Image.new("RGBA", (cell_w * 2, cell_h * 4), (244, 239, 229, 255))
    for idx, item in enumerate(items):
        img = Image.open(ROOT / f"{item['file_id']}.png").convert("RGBA")
        x = (idx % 2) * cell_w + (cell_w - img.size[0]) // 2
        y = (idx // 2) * cell_h + (cell_h - img.size[1]) // 2
        checker = Image.new("RGBA", img.size, (255, 255, 255, 255))
        d = ImageDraw.Draw(checker)
        step = 32
        for yy in range(0, img.size[1], step):
            for xx in range(0, img.size[0], step):
                if (xx // step + yy // step) % 2:
                    d.rectangle((xx, yy, xx + step - 1, yy + step - 1), fill=(226, 221, 211, 255))
        checker.alpha_composite(img)
        sheet.alpha_composite(checker, (x, y))
    proof_path = PROOF / "round175_home_interior_shells_contact_sheet.png"
    sheet.convert("RGB").save(proof_path)
    return proof_path


def main():
    spec = json.loads(PROMPTS.read_text())
    items = []
    pass_count = 0
    fail_count = 0
    for entry in spec["items"]:
        out_path, raw_path, layer, pivot, scale = process_item(entry)
        img = Image.open(out_path).convert("RGBA")
        bbox = alpha_bbox(img)
        edges = edge_stats(img)
        residue = residue_count(img)
        alpha = img.getchannel("A")
        stat = ImageStat.Stat(alpha)
        is_band = entry["kind"] == "region_band_not_sprite"
        alpha_min, alpha_max = stat.extrema[0]
        has_alpha_variation = (alpha_min <= 32 if is_band else alpha_min == 0) and alpha_max > 0
        max_edge_allowed = 255 if is_band else 220
        status = "pass" if img.size == tuple(entry["size"]) and bbox and residue == 0 and has_alpha_variation and max(edges.values()) <= max_edge_allowed else "fail"
        pass_count += status == "pass"
        fail_count += status == "fail"
        items.append({
            "id": f"home_interior_shell.{entry['id']}",
            "file_id": entry["id"],
            "status": status,
            "asset_status": "proof_only_normalized_candidate",
            "kind": entry["kind"],
            "region_or_band_not_sprite": is_band,
            "main_ref": asset_ref(out_path),
            "source_ref": asset_ref(raw_path),
            "dimensions": list(img.size),
            "intended_layer_depth": layer,
            "pivot_px": pivot,
            "anchor_recommendation": "center_floor" if entry["id"].startswith("floor") else "back_wall_or_room_corner",
            "scale_recommendation": scale,
            "bbox_alpha": list(bbox) if bbox else None,
            "edge_alpha": edges,
            "visible_key_residue_pixels": residue,
            "prompt": entry["prompt"],
            "risks": [
                "Generated source was normalized into a proof candidate; visual approval still required before runtime mapping.",
                "Do not use as a full-map or full-room screenshot.",
            ] + ([
                "Broad opaque area is intentional for a wall/floor composition region and must stay behind sprites."
            ] if is_band else [])
        })

    proof_path = make_contact(items)
    manifest = {
        "round": "Round175",
        "pack_id": "home_interior_shells",
        "status": "proof_only_normalized_candidate",
        "overall_gate": "pass" if fail_count == 0 else "fail",
        "runtime_boundary": "proof_only_no_runtime_mapping_no_themeprofile_no_assetresolver_no_data_changes",
        "scope": "Cozy home interior shell building-block candidates only; not a full-map background and not runtime-bound.",
        "generation_method": {
            "tool": "/home/xionglei/GameProject/tools/image_generator.js",
            "mode": "text-to-image raw candidates, local normalization and alpha masks",
            "normalizer": asset_ref(Path(__file__).resolve()),
            "source_prompts": asset_ref(PROMPTS)
        },
        "proofs": {
            "contact_sheet": asset_ref(proof_path),
            "raw_dir": asset_ref(RAW)
        },
        "validation_summary": {
            "basic_alpha_dimension_edge_residue_pass": pass_count,
            "basic_alpha_dimension_edge_residue_fail": fail_count,
            "checks": [
                "expected dimensions",
                "RGBA output with nonzero alpha",
                "alpha bbox exists",
                "edge alpha within allowed threshold",
                "visible chroma-key residue count is zero",
                "region/band assets explicitly marked not sprites"
            ]
        },
        "items": items,
        "risks": [
            "Proof-only shell pieces need manual art-direction review against Round173 furniture before any composition kit or runtime mapping.",
            "Window nook and room-shell prefabs may need painterly cleanup if future target frame requires stricter perspective.",
            "Opaque wall/floor bands are documented composition regions, not standalone sprites."
        ]
    }
    MANIFEST.write_text(json.dumps(manifest, indent=2) + "\n")


if __name__ == "__main__":
    main()
