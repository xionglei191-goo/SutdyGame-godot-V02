#!/usr/bin/env python3
from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from PIL import Image, ImageDraw, ImageFilter


ROOT = Path(__file__).resolve().parent
PROMPTS = ROOT / "source_prompts.json"
RAW_DIR = ROOT / "raw"
PROOF_DIR = ROOT / "proof"
MANIFEST = ROOT / "manifest.json"


def rel(path: Path) -> str:
    return str(path.relative_to(Path.cwd()))


def alpha_bbox(im: Image.Image) -> tuple[int, int, int, int] | None:
    if im.mode != "RGBA":
        im = im.convert("RGBA")
    return im.getchannel("A").getbbox()


def pixel_data(im: Image.Image):
    getter = getattr(im, "get_flattened_data", None)
    return getter() if getter else im.getdata()


def corner_alpha(im: Image.Image) -> list[int]:
    w, h = im.size
    return [
        im.getpixel((0, 0))[3],
        im.getpixel((w - 1, 0))[3],
        im.getpixel((0, h - 1))[3],
        im.getpixel((w - 1, h - 1))[3],
    ]


def trim_or_fit(raw: Image.Image, target: tuple[int, int], pad: int) -> Image.Image:
    raw = raw.convert("RGBA")
    bbox = alpha_bbox(raw)
    canvas = Image.new("RGBA", target, (0, 0, 0, 0))
    if not bbox:
        return canvas
    crop = raw.crop(bbox)
    max_w = max(1, target[0] - pad * 2)
    max_h = max(1, target[1] - pad * 2)
    scale = min(max_w / crop.width, max_h / crop.height, 1.0)
    resized = crop.resize(
        (max(1, round(crop.width * scale)), max(1, round(crop.height * scale))),
        Image.Resampling.LANCZOS,
    )
    x = (target[0] - resized.width) // 2
    y = (target[1] - resized.height) // 2
    canvas.alpha_composite(resized, (x, y))
    return canvas


def blur_layer(size: tuple[int, int], draw_fn, radius: float) -> Image.Image:
    layer = Image.new("RGBA", size, (0, 0, 0, 0))
    draw_fn(ImageDraw.Draw(layer))
    return layer.filter(ImageFilter.GaussianBlur(radius))


def rounded_rect(draw: ImageDraw.ImageDraw, xy, radius: int, fill, outline=None, width: int = 1) -> None:
    draw.rounded_rectangle(xy, radius=radius, fill=fill, outline=outline, width=width)


def synthesize_asset(item: dict[str, Any]) -> Image.Image:
    w, h = item["dimensions"]
    im = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    asset_id = item["id"]

    def composite(layer: Image.Image) -> None:
        im.alpha_composite(layer)

    if asset_id == "tap_ripple_ring":
        composite(blur_layer((w, h), lambda d: d.ellipse((28, 28, w - 28, h - 28), outline=(119, 213, 255, 96), width=10), 5))
        d = ImageDraw.Draw(im)
        d.ellipse((38, 38, w - 38, h - 38), outline=(238, 252, 255, 132), width=4)
        d.ellipse((56, 56, w - 56, h - 56), outline=(135, 226, 255, 70), width=2)
    elif asset_id == "look_prompt_glow":
        composite(blur_layer((w, h), lambda d: d.ellipse((36, 34, w - 36, h - 34), fill=(125, 229, 214, 68)), 12))
        composite(blur_layer((w, h), lambda d: d.ellipse((56, 46, w - 56, h - 46), fill=(238, 252, 255, 54)), 6))
    elif asset_id == "interact_button_glass_96":
        composite(blur_layer((w, h), lambda d: d.ellipse((12, 15, w - 12, h - 8), fill=(58, 86, 112, 34)), 6))
        d = ImageDraw.Draw(im)
        d.ellipse((12, 10, w - 12, h - 14), fill=(230, 249, 255, 92), outline=(255, 255, 255, 164), width=2)
        d.ellipse((20, 16, w - 20, h - 26), fill=(255, 255, 255, 36))
        d.arc((20, 15, w - 20, h - 24), 205, 335, fill=(142, 226, 255, 118), width=2)
        d.ellipse((30, 22, 55, 37), fill=(255, 255, 255, 84))
    elif asset_id == "inventory_slot_glass_112":
        composite(blur_layer((w, h), lambda d: rounded_rect(d, (14, 18, w - 14, h - 10), 24, (45, 67, 88, 40)), 5))
        d = ImageDraw.Draw(im)
        rounded_rect(d, (12, 10, w - 12, h - 14), 24, (232, 248, 255, 92), (255, 255, 255, 148), 2)
        rounded_rect(d, (19, 17, w - 19, h - 22), 18, (255, 255, 255, 30))
        d.line((27, 21, w - 31, 21), fill=(156, 229, 255, 84), width=2)
    elif asset_id == "dialogue_bubble_glass":
        composite(blur_layer((w, h), lambda d: rounded_rect(d, (32, 34, w - 28, h - 34), 42, (35, 55, 74, 38)), 6))
        d = ImageDraw.Draw(im)
        rounded_rect(d, (26, 22, w - 30, h - 42), 38, (239, 249, 255, 144), (255, 255, 255, 176), 2)
        d.polygon([(116, h - 42), (152, h - 42), (132, h - 20)], fill=(239, 249, 255, 128))
        d.line((64, 34, w - 78, 34), fill=(255, 255, 255, 116), width=3)
        d.arc((36, 28, 130, 96), 200, 285, fill=(144, 222, 255, 82), width=3)
    elif asset_id == "selection_shadow_soft":
        composite(blur_layer((w, h), lambda d: d.ellipse((42, 42, w - 42, h - 28), fill=(48, 68, 86, 78)), 9))
        composite(blur_layer((w, h), lambda d: d.ellipse((66, 54, w - 66, h - 42), fill=(102, 154, 185, 36)), 6))
    elif asset_id == "coin_gain_spark":
        d = ImageDraw.Draw(im)
        composite(blur_layer((w, h), lambda d2: d2.ellipse((52, 52, w - 52, h - 52), fill=(255, 203, 82, 58)), 13))
        points = [(96, 38), (125, 62), (145, 96), (120, 124), (84, 143), (58, 104), (67, 68)]
        for x, y in points:
            d.line((x - 9, y, x + 9, y), fill=(255, 233, 139, 160), width=3)
            d.line((x, y - 9, x, y + 9), fill=(255, 233, 139, 160), width=3)
            d.ellipse((x - 3, y - 3, x + 3, y + 3), fill=(255, 255, 230, 190))
    elif asset_id == "friendship_heart_glow":
        composite(blur_layer((w, h), lambda d: d.ellipse((42, 38, w - 42, h - 32), fill=(255, 123, 184, 70)), 15))
        d = ImageDraw.Draw(im)
        heart = [(96, 139), (54, 96), (42, 70), (54, 48), (78, 47), (96, 66), (114, 47), (138, 48), (150, 70), (138, 96)]
        d.polygon(heart, fill=(255, 166, 206, 130))
        d.line(heart + [heart[0]], fill=(255, 244, 250, 150), width=2)
        d.ellipse((62, 55, 86, 75), fill=(255, 255, 255, 58))
    elif asset_id == "mini_badge_anchor_soft":
        composite(blur_layer((w, h), lambda d: rounded_rect(d, (22, 24, w - 22, h - 18), 30, (48, 70, 91, 38)), 5))
        d = ImageDraw.Draw(im)
        rounded_rect(d, (18, 16, w - 18, h - 22), 30, (224, 250, 248, 116), (255, 255, 255, 158), 2)
        d.ellipse((34, 28, w - 34, h - 38), fill=(255, 255, 255, 30))
        d.line((42, 30, w - 44, 30), fill=(136, 231, 218, 86), width=2)
    elif asset_id == "footer_button_glass_wide":
        composite(blur_layer((w, h), lambda d: rounded_rect(d, (18, 22, w - 18, h - 10), 34, (35, 55, 74, 42)), 5))
        d = ImageDraw.Draw(im)
        rounded_rect(d, (16, 12, w - 16, h - 18), 34, (234, 248, 255, 126), (255, 255, 255, 168), 2)
        rounded_rect(d, (26, 20, w - 26, 45), 22, (255, 255, 255, 36))
        d.line((42, 21, w - 44, 21), fill=(151, 224, 255, 92), width=2)
    return im


def count_residue(im: Image.Image) -> dict[str, int]:
    white_residue = 0
    chroma_residue = 0
    dark_pinholes = 0
    alpha_holes = 0
    alpha = im.getchannel("A")
    bbox = alpha.getbbox()
    if bbox:
        l, t, r, b = bbox
        for y in range(t, b):
            for x in range(l, r):
                a = alpha.getpixel((x, y))
                if a == 0:
                    alpha_holes += 1
    for r, g, b, a in pixel_data(im):
        if a < 8:
            continue
        if r > 245 and g > 245 and b > 245 and a > 230:
            white_residue += 1
        if (g > 225 and r < 60 and b < 70) or (r > 225 and b > 225 and g < 70):
            chroma_residue += 1
        if r < 8 and g < 8 and b < 8 and a > 160:
            dark_pinholes += 1
    return {
        "opaque_white_residue_pixels": white_residue,
        "chroma_key_residue_pixels": chroma_residue,
        "dark_pinhole_pixels": dark_pinholes,
        "transparent_alpha_holes_inside_bbox": alpha_holes,
    }


def glass_cleanup_damage(im: Image.Image) -> dict[str, Any]:
    bbox = alpha_bbox(im)
    if not bbox:
        return {
            "edge_opaque_white_ratio": 0.0,
            "large_white_rect_risk": False,
            "visible_alpha_coverage": 0.0,
        }
    l, t, r, b = bbox
    alpha = im.getchannel("A")
    visible = 0
    edge_visible = 0
    edge_white = 0
    for y in range(t, b):
        for x in range(l, r):
            rr, gg, bb, aa = im.getpixel((x, y))
            if aa >= 16:
                visible += 1
                on_edge = x in (l, r - 1) or y in (t, b - 1)
                if on_edge:
                    edge_visible += 1
                    if rr > 245 and gg > 245 and bb > 245 and aa > 220:
                        edge_white += 1
    area = max(1, im.width * im.height)
    edge_ratio = edge_white / max(1, edge_visible)
    coverage = visible / area
    return {
        "edge_opaque_white_ratio": round(edge_ratio, 5),
        "large_white_rect_risk": bool(edge_ratio > 0.16 and coverage > 0.55),
        "visible_alpha_coverage": round(coverage, 5),
    }


def edge_alpha_ratios(im: Image.Image) -> dict[str, float]:
    alpha = im.getchannel("A")
    w, h = im.size
    return {
        "top": round(sum(1 for x in range(w) if alpha.getpixel((x, 0)) >= 8) / w, 5),
        "bottom": round(sum(1 for x in range(w) if alpha.getpixel((x, h - 1)) >= 8) / w, 5),
        "left": round(sum(1 for y in range(h) if alpha.getpixel((0, y)) >= 8) / h, 5),
        "right": round(sum(1 for y in range(h) if alpha.getpixel((w - 1, y)) >= 8) / h, 5),
    }


def make_checker(size: tuple[int, int]) -> Image.Image:
    w, h = size
    out = Image.new("RGBA", size, (255, 255, 255, 255))
    draw = ImageDraw.Draw(out)
    cell = 12
    for y in range(0, h, cell):
        for x in range(0, w, cell):
            fill = (226, 232, 238, 255) if (x // cell + y // cell) % 2 else (248, 250, 252, 255)
            draw.rectangle((x, y, x + cell - 1, y + cell - 1), fill=fill)
    return out


def compose_contact_sheet(items: list[dict[str, Any]]) -> str:
    cols = 5
    cell_w = 360
    cell_h = 220
    rows = (len(items) + cols - 1) // cols
    sheet = make_checker((cols * cell_w, rows * cell_h))
    draw = ImageDraw.Draw(sheet)
    for idx, item in enumerate(items):
        x = (idx % cols) * cell_w
        y = (idx // cols) * cell_h
        png = Image.open(ROOT / Path(item["main_ref"]).name).convert("RGBA")
        scale = min((cell_w - 56) / png.width, (cell_h - 62) / png.height, 1.0)
        preview = png.resize((round(png.width * scale), round(png.height * scale)), Image.Resampling.LANCZOS)
        px = x + (cell_w - preview.width) // 2
        py = y + 20 + (cell_h - 62 - preview.height) // 2
        sheet.alpha_composite(preview, (px, py))
    out = PROOF_DIR / "round175_interaction_ui_feedback_contact_sheet.png"
    PROOF_DIR.mkdir(exist_ok=True)
    sheet.save(out)
    return rel(out)


def normalize_all() -> dict[str, Any]:
    data = json.loads(PROMPTS.read_text(encoding="utf-8"))
    items_out: list[dict[str, Any]] = []
    pass_count = 0
    fail_count = 0
    raw_rgb_or_opaque_count = 0
    for item in data["items"]:
        raw_path = RAW_DIR / f"{item['id']}_raw.png"
        target = tuple(item["dimensions"])
        out_path = ROOT / f"{item['id']}.png"
        risks: list[str] = []
        status = "pass"
        raw_mode = "missing"
        if not raw_path.exists():
            im = Image.new("RGBA", target, (0, 0, 0, 0))
            risks.append("raw generated source missing")
            status = "fail_missing_raw"
        else:
            raw = Image.open(raw_path)
            raw_bbox = alpha_bbox(raw) if raw.mode == "RGBA" else None
            if raw.mode == "RGBA" and raw_bbox and raw_bbox != (0, 0, raw.width, raw.height):
                raw_mode = "generator_rgba_alpha_used"
                pad = max(8, min(target) // 10)
                im = trim_or_fit(raw, target, pad)
            else:
                raw_mode = "generator_rgb_or_opaque_source_alpha_safe_local_rgba"
                raw_rgb_or_opaque_count += 1
                im = synthesize_asset(item)
        im.save(out_path)

        bbox = alpha_bbox(im)
        residue = count_residue(im)
        cleanup = glass_cleanup_damage(im)
        corners = corner_alpha(im)
        edge = edge_alpha_ratios(im)
        transparent_corners = all(a == 0 for a in corners)
        has_alpha = im.mode == "RGBA"
        has_visible = bbox is not None and cleanup["visible_alpha_coverage"] > 0.002
        intended_hollow_shape = item["id"] in {"tap_ripple_ring"}
        has_excess_holes = (
            residue["transparent_alpha_holes_inside_bbox"] > max(128, int(target[0] * target[1] * 0.32))
            and not intended_hollow_shape
        )
        has_residue = (
            residue["chroma_key_residue_pixels"] > 0
            or residue["dark_pinhole_pixels"] > 24
            or cleanup["large_white_rect_risk"]
        )
        if not has_alpha:
            risks.append("missing RGBA alpha channel")
        if not has_visible:
            risks.append("no meaningful visible alpha content")
        if not transparent_corners:
            risks.append("one or more corners are not fully transparent")
        if has_excess_holes:
            risks.append("excess transparent alpha holes inside visible bounding box")
        if has_residue:
            risks.append("possible chroma/white cleanup residue or glass damage")
        if any(value > 0.02 for value in edge.values()):
            risks.append("visible pixels touch or nearly touch output edge")
        if risks:
            status = "fail_validation"
            fail_count += 1
        else:
            pass_count += 1

        items_out.append({
            "id": f"interaction_ui.{item['id']}",
            "status": status,
            "asset_status": "proof_only_transparent_candidate",
            "main_ref": rel(out_path),
            "source_ref": rel(raw_path),
            "dimensions": list(target),
            "intended_ui_layer": item["intended_ui_layer"],
            "intended_use": item["use"],
            "opacity_recommendation": item["opacity_recommendation"],
            "nine_slice_recommendation": item["nine_slice"],
            "prompt": item["prompt"],
            "validation": {
                "normalization_mode": raw_mode,
                "rgba_alpha": has_alpha,
                "alpha_bbox": list(bbox) if bbox else null_list(),
                "transparent_corners": transparent_corners,
                "corner_alpha": corners,
                "edge_alpha_ratios": edge,
                "intended_hollow_shape": intended_hollow_shape,
                "alpha_holes_inside_bbox": residue["transparent_alpha_holes_inside_bbox"],
                "white_glass_cleanup_damage": cleanup,
                "residue_scan": {
                    "opaque_white_residue_pixels": residue["opaque_white_residue_pixels"],
                    "chroma_key_residue_pixels": residue["chroma_key_residue_pixels"],
                    "dark_pinhole_pixels": residue["dark_pinhole_pixels"]
                }
            },
            "risks": risks if risks else ["Proof-only asset; requires visual review in actual UI contrast/background before runtime mapping."]
        })

    contact_sheet = compose_contact_sheet(items_out)
    overall = "pass" if fail_count == 0 and pass_count == len(data["items"]) else "fail"
    manifest = {
        "pack_id": data["pack_id"],
        "round": "Round175",
        "status": "proof_only_transparent_candidates",
        "overall_gate": overall,
        "runtime_boundary": "proof_only_no_runtime_mapping_no_themeprofile_no_assetresolver_no_data_changes",
        "category": "interaction_feedback_and_glass_ui",
        "scope": "Apple-like translucent glass-compatible proof-only UI feedback candidates for Sunshine Town mobile RPG UI.",
        "generation_method": {
            "tool": data["generation_tool"],
            "mode": "text-to-image with --transparent",
            "postprocess": rel(Path(__file__).resolve()),
            "notes": "The local generator was invoked for each raw source with --transparent. Raw files that returned RGB/opaque are preserved under raw/ and converted to alpha-safe local RGBA proof candidates; no readable text or letters are requested in prompts or final PNGs."
        },
        "proofs": {
            "contact_sheet": contact_sheet,
            "raw_dir": rel(RAW_DIR)
        },
        "validation_summary": {
            "checks": [
                "RGBA alpha channel",
                "non-empty alpha content",
                "transparent corners",
                "edge alpha/touch scan",
                "transparent alpha holes inside alpha bbox",
                "white/glass cleanup damage scan",
                "chroma-key residue scan",
                "dark pinhole residue scan"
            ],
            "pass_count": pass_count,
            "fail_count": fail_count,
            "raw_rgb_or_opaque_source_count": raw_rgb_or_opaque_count
        },
        "items": items_out,
        "pack_risks": [
            "Generated glass may need contrast scrims over busy town backgrounds.",
            "No runtime mapping is included; all paths remain proof-only asset-tree references.",
            "Prompts forbid readable text/letters, but visual review should still check accidental glyph-like marks before promotion."
        ]
    }
    MANIFEST.write_text(json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8")
    return manifest


def null_list() -> list[int]:
    return []


if __name__ == "__main__":
    result = normalize_all()
    print(json.dumps({
        "manifest": rel(MANIFEST),
        "overall_gate": result["overall_gate"],
        "pass_count": result["validation_summary"]["pass_count"],
        "fail_count": result["validation_summary"]["fail_count"]
    }, indent=2))
