#!/usr/bin/env python3
import json
import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageStat


ROOT = Path(__file__).resolve().parent
RAW = ROOT / "raw"
PROOF = ROOT / "proof"
PROMPTS = ROOT / "source_prompts.json"
MANIFEST = ROOT / "round176_place_interior_shells_manifest.json"


def asset_ref(path: Path) -> str:
    return str(path.relative_to(ROOT.parents[4]))


def crop_square(img: Image.Image) -> Image.Image:
    w, h = img.size
    side = min(w, h)
    x = (w - side) // 2
    y = (h - side) // 2
    return img.crop((x, y, x + side, y + side))


def center_crop_ratio(img: Image.Image, ratio: float) -> Image.Image:
    w, h = img.size
    current = w / h
    if current > ratio:
        nw = int(h * ratio)
        x = (w - nw) // 2
        return img.crop((x, 0, x + nw, h))
    nh = int(w / ratio)
    y = (h - nh) // 2
    return img.crop((0, y, w, y + nh))


def prep_raw(item_id: str, size: tuple[int, int]) -> Image.Image:
    raw_path = RAW / f"{item_id}_raw.png"
    if not raw_path.exists():
        raise FileNotFoundError(raw_path)
    raw = Image.open(raw_path).convert("RGBA")
    base = center_crop_ratio(crop_square(raw), size[0] / size[1])
    return base.resize(size, Image.Resampling.LANCZOS).filter(ImageFilter.GaussianBlur(6))


def texture(size: tuple[int, int], color: tuple[int, int, int], raw: Image.Image, strength: float = 0.08) -> Image.Image:
    w, h = size
    img = Image.new("RGBA", size, (*color, 255))
    raw = raw.resize(size, Image.Resampling.LANCZOS)
    img = Image.blend(img, raw, strength)
    pix = img.load()
    for y in range(h):
        for x in range(w):
            r, g, b, a = pix[x, y]
            grain = int(5 * math.sin((x + y * 0.35) / 19.0) + 3 * math.sin(y / 9.0))
            shade = int(12 * y / max(1, h))
            pix[x, y] = (
                max(0, min(255, r + grain - shade)),
                max(0, min(255, g + grain // 2 - shade)),
                max(0, min(255, b + grain // 3 - shade)),
                a,
            )
    return img


def edge_fade_mask(size: tuple[int, int], margin_x: int, margin_y: int, base: int = 245) -> Image.Image:
    w, h = size
    mask = Image.new("L", size, 0)
    draw = ImageDraw.Draw(mask)
    draw.rectangle((margin_x, margin_y, w - margin_x - 1, h - margin_y - 1), fill=base)
    return mask.filter(ImageFilter.GaussianBlur(max(margin_x, margin_y) / 2))


def vertical_band_mask(size: tuple[int, int], fade: int = 24, base: int = 245) -> Image.Image:
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
    return mask.filter(ImageFilter.GaussianBlur(1.2))


def oval_mask(size: tuple[int, int], inset: int = 18, base: int = 235, blur: int = 10) -> Image.Image:
    w, h = size
    mask = Image.new("L", size, 0)
    draw = ImageDraw.Draw(mask)
    draw.ellipse((inset, inset, w - inset - 1, h - inset - 1), fill=base)
    return mask.filter(ImageFilter.GaussianBlur(blur))


def rounded_mask(size: tuple[int, int], radius: int = 42, blur: int = 8, inset: int = 12, base: int = 245) -> Image.Image:
    w, h = size
    mask = Image.new("L", size, 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle((inset, inset, w - inset - 1, h - inset - 1), radius=radius, fill=base)
    return mask.filter(ImageFilter.GaussianBlur(blur))


def shadow_ellipse(draw: ImageDraw.ImageDraw, box: tuple[int, int, int, int], alpha: int = 55) -> None:
    draw.ellipse(box, fill=(90, 62, 48, alpha))


def wood_counter(item_id: str, size: tuple[int, int]) -> Image.Image:
    raw = prep_raw(item_id, size)
    img = Image.new("RGBA", size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img, "RGBA")
    w, h = size
    shadow_ellipse(draw, (68, h - 86, w - 54, h - 22), 46)
    draw.rounded_rectangle((74, 112, w - 74, h - 82), radius=28, fill=(180, 112, 64, 238))
    draw.polygon([(92, 112), (w - 58, 112), (w - 96, 154), (62, 154)], fill=(221, 157, 92, 242))
    draw.rounded_rectangle((96, 152, w - 100, h - 86), radius=18, fill=(166, 96, 56, 244))
    for x in range(130, w - 120, 82):
        draw.line((x, 158, x - 12, h - 94), fill=(116, 72, 44, 42), width=3)
    draw.rounded_rectangle((138, 92, 260, 126), radius=14, fill=(235, 188, 127, 232))
    draw.rounded_rectangle((300, 96, 400, 132), radius=15, fill=(146, 183, 160, 226))
    draw.ellipse((350, 77, 388, 112), fill=(241, 189, 92, 226))
    draw.ellipse((380, 78, 420, 114), fill=(226, 126, 92, 226))
    highlight = texture(size, (255, 220, 168), raw, 0.06)
    highlight.putalpha(rounded_mask(size, 44, 20, 34, 34))
    img.alpha_composite(highlight)
    return img.filter(ImageFilter.GaussianBlur(0.2))


def shop_shelf_band(item_id: str, size: tuple[int, int]) -> Image.Image:
    raw = prep_raw(item_id, size)
    img = texture(size, (230, 184, 137), raw, 0.1)
    draw = ImageDraw.Draw(img, "RGBA")
    w, h = size
    for y in (124, 216, 300):
        draw.rounded_rectangle((46, y, w - 48, y + 18), radius=8, fill=(133, 82, 49, 126))
        draw.line((54, y + 4, w - 58, y + 4), fill=(250, 219, 168, 62), width=2)
    colors = [(132, 184, 166, 210), (238, 184, 95, 210), (199, 118, 98, 210), (245, 220, 165, 210)]
    for row, y in enumerate((82, 176, 260)):
        for i, x in enumerate(range(82, w - 92, 76)):
            c = colors[(i + row) % len(colors)]
            draw.rounded_rectangle((x, y, x + 34, y + 42), radius=10, fill=c)
            draw.ellipse((x + 4, y - 6, x + 30, y + 10), fill=(255, 240, 196, 80))
    draw.rounded_rectangle((0, h - 42, w, h), radius=0, fill=(116, 74, 45, 42))
    img.putalpha(vertical_band_mask(size, 18, 242))
    return img


def notice_board(item_id: str, size: tuple[int, int]) -> Image.Image:
    raw = prep_raw(item_id, size)
    img = Image.new("RGBA", size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img, "RGBA")
    w, h = size
    shadow_ellipse(draw, (80, h - 76, w - 74, h - 24), 44)
    draw.rounded_rectangle((112, 64, w - 112, h - 96), radius=34, fill=(173, 108, 64, 236))
    draw.rounded_rectangle((136, 90, w - 136, h - 130), radius=22, fill=(238, 202, 142, 238))
    blanks = [(164, 118, 234, 164), (260, 112, 344, 158), (184, 180, 292, 226), (318, 180, 392, 230)]
    for i, box in enumerate(blanks):
        fill = [(244, 224, 183, 226), (186, 217, 197, 226), (232, 176, 151, 226), (213, 226, 164, 226)][i]
        draw.rounded_rectangle(box, radius=10, fill=fill)
    draw.rounded_rectangle((102, h - 108, 132, h - 38), radius=10, fill=(125, 81, 52, 232))
    draw.rounded_rectangle((w - 132, h - 108, w - 102, h - 38), radius=10, fill=(125, 81, 52, 232))
    glaze = texture(size, (255, 222, 170), raw, 0.05)
    glaze.putalpha(rounded_mask(size, 48, 18, 36, 30))
    img.alpha_composite(glaze)
    return img


def school_yard_mat(item_id: str, size: tuple[int, int]) -> Image.Image:
    raw = prep_raw(item_id, size)
    img = texture(size, (151, 202, 149), raw, 0.08)
    draw = ImageDraw.Draw(img, "RGBA")
    w, h = size
    draw.polygon([(0, h - 116), (w, h - 178), (w, h), (0, h)], fill=(207, 186, 145, 120))
    draw.line((0, h - 116, w, h - 178), fill=(124, 140, 96, 72), width=5)
    for x in range(38, w, 90):
        draw.ellipse((x, h - 90, x + 18, h - 76), fill=(120, 169, 107, 70))
    img.putalpha(edge_fade_mask(size, 22, 20, 234))
    return img


def reading_nook(item_id: str, size: tuple[int, int]) -> Image.Image:
    raw = prep_raw(item_id, size)
    img = Image.new("RGBA", size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img, "RGBA")
    w, h = size
    shadow_ellipse(draw, (72, h - 82, w - 54, h - 22), 44)
    draw.rounded_rectangle((92, 70, w - 106, h - 92), radius=30, fill=(170, 104, 60, 238))
    draw.rounded_rectangle((116, 96, w - 130, h - 176), radius=18, fill=(112, 75, 54, 124))
    book_colors = [(246, 205, 118, 220), (135, 187, 167, 220), (225, 135, 111, 220), (181, 159, 214, 220)]
    for shelf_y in (112, 154):
        x = 130
        while x < w - 164:
            bw = 12 + (x % 5) * 3
            draw.rounded_rectangle((x, shelf_y, x + bw, shelf_y + 38), radius=4, fill=book_colors[x % 4])
            x += bw + 6
    draw.rounded_rectangle((162, h - 166, w - 154, h - 94), radius=28, fill=(236, 168, 132, 232))
    draw.ellipse((w - 160, 90, w - 102, 154), fill=(250, 218, 138, 136))
    glaze = texture(size, (255, 225, 172), raw, 0.05)
    glaze.putalpha(rounded_mask(size, 52, 18, 34, 28))
    img.alpha_composite(glaze)
    return img


def waiting_pad(item_id: str, size: tuple[int, int]) -> Image.Image:
    raw = prep_raw(item_id, size)
    img = texture(size, (201, 183, 145), raw, 0.08)
    draw = ImageDraw.Draw(img, "RGBA")
    w, h = size
    for y in range(72, h - 40, 48):
        draw.arc((24, y - 34, w - 24, y + 90), 182, 356, fill=(139, 128, 105, 46), width=3)
    draw.ellipse((68, 46, w - 66, h - 38), outline=(112, 139, 104, 92), width=5)
    draw.ellipse((178, 106, w - 168, h - 78), fill=(96, 85, 74, 30))
    img.putalpha(oval_mask(size, 14, 232, 12))
    return img


def market_table(item_id: str, size: tuple[int, int]) -> Image.Image:
    raw = prep_raw(item_id, size)
    img = Image.new("RGBA", size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img, "RGBA")
    w, h = size
    shadow_ellipse(draw, (72, h - 86, w - 62, h - 24), 44)
    draw.polygon([(86, 130), (w - 80, 130), (w - 116, 190), (58, 190)], fill=(207, 132, 78, 240))
    draw.rounded_rectangle((78, 184, w - 110, h - 88), radius=18, fill=(154, 91, 54, 238))
    draw.rounded_rectangle((128, 126, w - 148, 166), radius=16, fill=(238, 217, 178, 232))
    for bx, by in ((136, 92), (250, 88), (342, 96)):
        draw.rounded_rectangle((bx, by, bx + 72, by + 48), radius=14, fill=(157, 112, 65, 228))
        for i in range(3):
            draw.ellipse((bx + 12 + i * 16, by + 10, bx + 32 + i * 16, by + 30), fill=[(234, 126, 84, 228), (242, 185, 83, 228), (137, 188, 113, 228)][(i + bx) % 3])
    glaze = texture(size, (255, 223, 168), raw, 0.05)
    glaze.putalpha(rounded_mask(size, 46, 20, 36, 26))
    img.alpha_composite(glaze)
    return img


def classroom_wall_band(item_id: str, size: tuple[int, int]) -> Image.Image:
    raw = prep_raw(item_id, size)
    img = texture(size, (234, 205, 161), raw, 0.08)
    draw = ImageDraw.Draw(img, "RGBA")
    w, h = size
    for x in (92, 260, 428):
        draw.rounded_rectangle((x, 70, x + 112, 188), radius=18, fill=(156, 193, 207, 156))
        draw.rounded_rectangle((x + 10, 82, x + 102, 178), radius=12, outline=(117, 91, 66, 116), width=5)
        draw.line((x + 56, 84, x + 56, 176), fill=(117, 91, 66, 76), width=3)
    draw.rounded_rectangle((48, h - 92, w - 48, h - 68), radius=10, fill=(128, 84, 51, 92))
    blanks = [(80, 220, 168, 276), (212, 218, 310, 280), (472, 222, 562, 274)]
    for i, box in enumerate(blanks):
        draw.rounded_rectangle(box, radius=12, fill=[(236, 182, 154, 188), (194, 218, 174, 188), (246, 224, 170, 188)][i])
    img.putalpha(vertical_band_mask(size, 18, 242))
    return img


BUILDERS = {
    "shop_counter_shell": wood_counter,
    "shop_display_shelf_wall": shop_shelf_band,
    "school_gate_notice_board_shell": notice_board,
    "school_yard_corner_mat": school_yard_mat,
    "bookshop_reading_nook_shell": reading_nook,
    "bus_stop_waiting_pad": waiting_pad,
    "plaza_market_table_shell": market_table,
    "classroom_window_wall_band": classroom_wall_band,
}

LAYER = {
    "shop_counter_shell": "interior_front_counter_prefab_above_floor_below_actor_front_overlap",
    "shop_display_shelf_wall": "shop_back_wall_region_behind_counter_and_props; deliberate broad band, not a standalone sprite",
    "school_gate_notice_board_shell": "front_area_prefab_near_school_gate_above_ground_below_actors",
    "school_yard_corner_mat": "school_yard_ground_region_below_props_and_actors; deliberate broad region, not a standalone sprite",
    "bookshop_reading_nook_shell": "bookshop_back_wall_prefab_above_wall_band_below_actor_front_overlap",
    "bus_stop_waiting_pad": "bus_stop_ground_region_below_round174_bus_stop_shelter_and_actors; deliberate broad region, not a standalone sprite",
    "plaza_market_table_shell": "plaza_front_area_table_prefab_above_ground_below_actor_front_overlap",
    "classroom_window_wall_band": "classroom_back_wall_region_behind_desks_and_props; deliberate broad band, not a standalone sprite",
}

PIVOT = {
    "shop_counter_shell": [256, 340],
    "shop_display_shelf_wall": [320, 384],
    "school_gate_notice_board_shell": [256, 352],
    "school_yard_corner_mat": [320, 192],
    "bookshop_reading_nook_shell": [256, 356],
    "bus_stop_waiting_pad": [256, 160],
    "plaza_market_table_shell": [256, 348],
    "classroom_window_wall_band": [320, 384],
}

SCALE = {
    "shop_counter_shell": "0.85-1.0 inside Round174 cozy_shop_front; align bottom to interior floor",
    "shop_display_shelf_wall": "1.0-1.2 horizontally behind shop_counter_shell",
    "school_gate_notice_board_shell": "0.75-0.95 near Round174 school_gate_prefab front corner",
    "school_yard_corner_mat": "1.0 as yard corner pad under low props; crop/overlap with terrain edge",
    "bookshop_reading_nook_shell": "0.8-1.0 inside Round174 bookshop_front interior layer",
    "bus_stop_waiting_pad": "0.85-1.1 under Round174 bus_stop_shelter footprint",
    "plaza_market_table_shell": "0.8-1.0 at plaza market/front-area depth, leave actor walkway clear",
    "classroom_window_wall_band": "1.0-1.2 behind school/classroom furniture and UI-safe props",
}


def alpha_bbox(img: Image.Image):
    return img.getchannel("A").getbbox()


def edge_stats(img: Image.Image) -> dict:
    alpha = img.getchannel("A")
    w, h = img.size
    return {
        "top_max_alpha": alpha.crop((0, 0, w, 1)).getextrema()[1],
        "bottom_max_alpha": alpha.crop((0, h - 1, w, h)).getextrema()[1],
        "left_max_alpha": alpha.crop((0, 0, 1, h)).getextrema()[1],
        "right_max_alpha": alpha.crop((w - 1, 0, w, h)).getextrema()[1],
    }


def residue_count(img: Image.Image) -> int:
    count = 0
    rgba = img.convert("RGBA")
    px = rgba.load()
    for y in range(rgba.height):
        for x in range(rgba.width):
            r, g, b, a = px[x, y]
            if a > 8 and ((g > 235 and r < 45 and b < 45) or (r > 235 and b > 235 and g < 75)):
                count += 1
    return count


def color_variance(img: Image.Image) -> float:
    rgb = img.convert("RGB")
    stat = ImageStat.Stat(rgb)
    return float(sum(stat.var))


def make_contact(items: list[dict]) -> Path:
    PROOF.mkdir(parents=True, exist_ok=True)
    cell_w, cell_h = 360, 250
    cols = 2
    rows = math.ceil(len(items) / cols)
    sheet = Image.new("RGBA", (cell_w * cols, cell_h * rows), (245, 240, 230, 255))
    checker = Image.new("RGBA", (cell_w, cell_h), (232, 226, 216, 255))
    cd = ImageDraw.Draw(checker)
    for y in range(0, cell_h, 24):
        for x in range(0, cell_w, 24):
            if (x // 24 + y // 24) % 2:
                cd.rectangle((x, y, x + 23, y + 23), fill=(255, 250, 240, 255))
    for idx, item in enumerate(items):
        img = Image.open(ROOT / f"{item['file_id']}.png").convert("RGBA")
        cell = checker.copy()
        scale = min((cell_w - 36) / img.width, (cell_h - 48) / img.height)
        resized = img.resize((int(img.width * scale), int(img.height * scale)), Image.Resampling.LANCZOS)
        x = (cell_w - resized.width) // 2
        y = (cell_h - resized.height) // 2 + 10
        cell.alpha_composite(resized, (x, y))
        d = ImageDraw.Draw(cell)
        d.rectangle((0, 0, cell_w, 28), fill=(78, 68, 58, 220))
        d.text((8, 7), item["file_id"], fill=(255, 250, 235, 255))
        sheet.alpha_composite(cell, ((idx % cols) * cell_w, (idx // cols) * cell_h))
    out = PROOF / "round176_place_interior_shells_contact_sheet.png"
    sheet.save(out)
    return out


def validate_item(item: dict, edge: dict, residue: int, variance: float) -> list[str]:
    errors = []
    if item["dimensions"] != item["expected_dimensions"]:
        errors.append("dimension mismatch")
    if item["bbox_alpha"] is None:
        errors.append("missing alpha bbox")
    if residue != 0:
        errors.append("visible chroma residue")
    edge_limit = 250 if item["region_or_band_not_sprite"] else 42
    if max(edge.values()) > edge_limit:
        errors.append(f"edge alpha exceeds {edge_limit}")
    if variance < 300:
        errors.append("low color variance / likely blank")
    return errors


def trim_prefab_alpha_noise(img: Image.Image, threshold: int = 3) -> Image.Image:
    out = img.convert("RGBA")
    alpha = out.getchannel("A")
    px = alpha.load()
    for y in range(alpha.height):
        for x in range(alpha.width):
            if px[x, y] <= threshold:
                px[x, y] = 0
    out.putalpha(alpha)
    return out


def main() -> None:
    data = json.loads(PROMPTS.read_text(encoding="utf-8"))
    items = []
    for spec in data["items"]:
        item_id = spec["id"]
        size = tuple(spec["size"])
        out = BUILDERS[item_id](item_id, size).convert("RGBA")
        if spec["kind"] != "region_band_not_sprite":
            out = trim_prefab_alpha_noise(out)
        out_path = ROOT / f"{item_id}.png"
        out.save(out_path)
        edge = edge_stats(out)
        residue = residue_count(out)
        variance = color_variance(out)
        bbox = alpha_bbox(out)
        kind = spec["kind"]
        item = {
            "id": f"place_interior_shell.{item_id}",
            "file_id": item_id,
            "status": "pass",
            "asset_status": "proof_only_normalized_candidate",
            "kind": kind,
            "region_or_band_not_sprite": kind == "region_band_not_sprite",
            "main_ref": asset_ref(out_path),
            "source_ref": asset_ref(RAW / f"{item_id}_raw.png"),
            "dimensions": list(out.size),
            "expected_dimensions": list(size),
            "intended_layer_depth": LAYER[item_id],
            "pivot_px": PIVOT[item_id],
            "anchor_recommendation": spec["anchor"],
            "scale_recommendation": SCALE[item_id],
            "bbox_alpha": list(bbox) if bbox else None,
            "edge_alpha": edge,
            "visible_key_residue_pixels": residue,
            "color_variance_rgb_sum": round(variance, 2),
            "prompt": spec["prompt"],
            "risks": [
                "Proof-only normalized candidate; visual approval is still required before any runtime mapping.",
                "No runtime, ThemeProfile, AssetResolver, data, shared test, todo, lesson, or doc mapping is included.",
                "Generated raw was used only as a source texture/color cue; final alpha and component shape were locally normalized."
            ]
        }
        if kind == "region_band_not_sprite":
            item["risks"].append("Broad opaque area is intentional for a region/band layer and must not be treated as a standalone pickup sprite.")
        errors = validate_item(item, edge, residue, variance)
        if errors:
            item["status"] = "fail"
            item["fail_reasons"] = errors
        items.append(item)

    contact = make_contact(items)
    failed = [item for item in items if item["status"] != "pass"]
    manifest = {
        "round": "Round176",
        "pack_id": "place_interior_shells",
        "status": "proof_only_normalized_candidate",
        "overall_gate": "pass" if not failed else "fail",
        "category": "place_interior_front_area_shell",
        "runtime_boundary": "proof_only_no_runtime_mapping_no_themeprofile_no_assetresolver_no_data_no_shared_tests",
        "scope": "Cozy town place interior/front-area shell building-block candidates only; no full scene screenshot and no runtime binding.",
        "compatibility_notes": [
            "Designed for visual comparison with Round174 place prefabs and Round175 interior shells.",
            "Use behind/around actors and furniture according to intended_layer_depth.",
            "No readable text/letters/numbers are intentionally drawn in final normalized PNGs."
        ],
        "generation_method": {
            "tool": "/home/xionglei/GameProject/tools/image_generator.js",
            "mode": "text-to-image raw candidates, then local deterministic normalization and alpha validation",
            "raw_generator": asset_ref(ROOT / "generate_raw_from_prompts.py"),
            "normalizer": asset_ref(ROOT / "normalize_validate_manifest.py"),
            "source_prompts": asset_ref(PROMPTS)
        },
        "proofs": {
            "contact_sheet": asset_ref(contact),
            "raw_dir": asset_ref(RAW)
        },
        "validation_summary": {
            "alpha_dimension_edge_residue_region_sprite_checks_pass": len(items) - len(failed),
            "alpha_dimension_edge_residue_region_sprite_checks_fail": len(failed),
            "checks": [
                "expected dimensions",
                "RGBA output with nonzero alpha bbox",
                "edge alpha threshold: <=42 for prefabs, <=250 for documented region/bands",
                "visible chroma-key residue count equals zero",
                "region/band items explicitly marked region_band_not_sprite",
                "color variance above blank-output threshold"
            ]
        },
        "items": items,
        "pack_risks": [
            "Proof-only candidates are not approval evidence for art_target_locked or runtime_visual_match.",
            "Large region/band PNGs may still need tiling/material replacement later; use only for composition review.",
            "No automated OCR was run; text avoidance is enforced by prompt and deterministic final drawing without glyph strokes."
        ]
    }
    MANIFEST.write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    print(json.dumps({
        "overall_gate": manifest["overall_gate"],
        "items": len(items),
        "failed": len(failed),
        "manifest": asset_ref(MANIFEST),
        "contact_sheet": asset_ref(contact)
    }, indent=2))


if __name__ == "__main__":
    main()
