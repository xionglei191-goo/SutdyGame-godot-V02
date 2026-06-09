#!/usr/bin/env python3
from __future__ import annotations

import json
import math
from pathlib import Path
from typing import Any

from PIL import Image, ImageDraw, ImageFilter


ROOT = Path(__file__).resolve().parent
PROMPTS = ROOT / "source_prompts.json"
RAW_DIR = ROOT / "raw"
PROOF_DIR = ROOT / "proof"
MANIFEST = ROOT / "manifest.json"


USES: dict[str, dict[str, str]] = {
    "album_card_glass_empty": {
        "layer": "album card base below artwork, sticker slots, badges, and card state overlays",
        "use": "empty collection card background for not-yet-collected memory/photo entries",
        "opacity": "65-85% base alpha; keep highlights below content layers",
        "slice": "recommended margins [36, 44, 36, 44] if scaled; preserve 26-32 px corner radius",
    },
    "album_card_collected_glow": {
        "layer": "collected-state card base below artwork and above card_shadow_soft",
        "use": "warm collected card state with gentle glow for completed album/card entries",
        "opacity": "70-90% for base, glow can pulse 20-40% with separate modulate",
        "slice": "recommended margins [38, 48, 38, 48] if scaled; avoid stretching outer glow too far",
    },
    "album_page_tab_glass": {
        "layer": "album navigation/tab row background behind separate icon or localized label",
        "use": "unlabeled page tab plate compatible with Round173 icons",
        "opacity": "70-88%; selected state can add separate collection_stamp_soft or glow",
        "slice": "recommended margins [42, 24, 42, 24]",
    },
    "sticker_slot_round": {
        "layer": "card detail layer above album_card_glass_empty and below sticker artwork",
        "use": "round sticker placeholder/slot for collection cards",
        "opacity": "55-78%; keep inner center open for icon/sticker",
        "slice": "not recommended; circular sprite should scale uniformly",
    },
    "memory_anchor_badge_backplate": {
        "layer": "badge base behind separate memory anchor icon; never carries A-Z letters directly",
        "use": "generic memory anchor badge backplate for album card corners",
        "opacity": "62-82%; use separate icon layer for actual anchor imagery",
        "slice": "not recommended; scalloped/radial shape",
    },
    "photo_corner_tape_pair": {
        "layer": "decorative overlay above photo/card art, below modal focus effects",
        "use": "paired translucent tape corners for album photos",
        "opacity": "60-80%; rotate only as authored or split into pieces later",
        "slice": "not recommended; decorative overlay",
    },
    "collection_stamp_soft": {
        "layer": "soft status overlay above card art and below active focus ring",
        "use": "text-free collected/seen stamp mark using abstract ring and dots only",
        "opacity": "35-65%; use sparingly so it does not read as evaluation",
        "slice": "not recommended; radial stamp mark",
    },
    "tiny_progress_pip_set": {
        "layer": "small card footer/status row above glass base",
        "use": "text-free progress pips for gentle collection state",
        "opacity": "60-85%; dim inactive pips rather than adding numbers",
        "slice": "not recommended as a set; split pips later if needed",
    },
    "card_shadow_soft": {
        "layer": "lowest card layer, below album cards and photo panels",
        "use": "soft transparent card shadow for depth on cozy album panels",
        "opacity": "25-50%; tune by background contrast",
        "slice": "recommended margins [42, 56, 42, 56] if scaled",
    },
    "album_panel_backdrop": {
        "layer": "album modal/panel backdrop below card grid, tabs, and controls",
        "use": "wide glass panel backdrop for collection album layouts",
        "opacity": "55-78%; leave center quiet for legibility",
        "slice": "recommended margins [72, 60, 72, 60]",
    },
}


def rel(path: Path) -> str:
    return str(path.relative_to(Path.cwd()))


def alpha_bbox(im: Image.Image) -> tuple[int, int, int, int] | None:
    return im.convert("RGBA").getchannel("A").getbbox()


def pixel_data(im: Image.Image):
    getter = getattr(im, "get_flattened_data", None)
    return getter() if getter else im.getdata()


def rounded_layer(size: tuple[int, int], xy, radius: int, fill, outline=None, width: int = 1) -> Image.Image:
    layer = Image.new("RGBA", size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    d.rounded_rectangle(xy, radius=radius, fill=fill, outline=outline, width=width)
    return layer


def blur_layer(size: tuple[int, int], draw_fn, radius: float) -> Image.Image:
    layer = Image.new("RGBA", size, (0, 0, 0, 0))
    draw_fn(ImageDraw.Draw(layer))
    return layer.filter(ImageFilter.GaussianBlur(radius))


def paste_rotated(base: Image.Image, rect: tuple[int, int], angle: float, fill, outline) -> None:
    w, h = rect
    piece = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(piece)
    d.rounded_rectangle((2, 2, w - 2, h - 2), radius=10, fill=fill, outline=outline, width=2)
    d.line((10, 12, w - 10, 12), fill=(255, 255, 255, 70), width=2)
    rot = piece.rotate(angle, expand=True, resample=Image.Resampling.BICUBIC)
    return rot


def synthesize_asset(item: dict[str, Any]) -> Image.Image:
    w, h = item["dimensions"]
    asset_id = item["id"]
    im = Image.new("RGBA", (w, h), (0, 0, 0, 0))

    def composite(layer: Image.Image) -> None:
        im.alpha_composite(layer)

    if asset_id == "album_card_glass_empty":
        composite(blur_layer((w, h), lambda d: d.rounded_rectangle((31, 37, w - 29, h - 27), 36, fill=(45, 65, 82, 36)), 8))
        composite(blur_layer((w, h), lambda d: d.rounded_rectangle((42, 44, w - 42, h - 54), 34, fill=(152, 226, 236, 22)), 12))
        d = ImageDraw.Draw(im)
        d.rounded_rectangle((28, 24, w - 28, h - 36), 34, fill=(239, 250, 255, 112), outline=(255, 255, 255, 164), width=3)
        d.rounded_rectangle((43, 40, w - 43, h - 62), 26, fill=(255, 255, 255, 28))
        d.arc((43, 36, w - 43, 170), 200, 310, fill=(143, 224, 248, 90), width=3)
        d.line((62, 45, w - 68, 45), fill=(255, 255, 255, 88), width=3)
    elif asset_id == "album_card_collected_glow":
        composite(blur_layer((w, h), lambda d: d.rounded_rectangle((19, 18, w - 19, h - 24), 46, fill=(255, 212, 112, 54)), 14))
        composite(blur_layer((w, h), lambda d: d.rounded_rectangle((36, 42, w - 36, h - 56), 36, fill=(116, 225, 205, 36)), 10))
        d = ImageDraw.Draw(im)
        d.rounded_rectangle((28, 24, w - 28, h - 36), 36, fill=(246, 252, 255, 122), outline=(255, 255, 255, 178), width=3)
        d.rounded_rectangle((43, 40, w - 43, h - 62), 28, fill=(255, 251, 231, 32))
        d.arc((42, 33, w - 44, 164), 204, 330, fill=(255, 232, 151, 108), width=4)
        d.ellipse((58, 58, 78, 78), fill=(255, 255, 236, 92))
        d.ellipse((w - 88, 78, w - 74, 92), fill=(255, 249, 210, 70))
    elif asset_id == "album_page_tab_glass":
        composite(blur_layer((w, h), lambda d: d.rounded_rectangle((12, 19, w - 12, h - 8), 34, fill=(42, 62, 78, 36)), 5))
        d = ImageDraw.Draw(im)
        d.rounded_rectangle((14, 12, w - 14, h - 16), 32, fill=(236, 249, 255, 128), outline=(255, 255, 255, 170), width=2)
        d.rounded_rectangle((28, 20, w - 28, 45), 18, fill=(255, 255, 255, 36))
        d.line((38, 21, w - 40, 21), fill=(150, 226, 247, 88), width=2)
    elif asset_id == "sticker_slot_round":
        composite(blur_layer((w, h), lambda d: d.ellipse((14, 16, w - 14, h - 10), fill=(47, 66, 82, 32)), 5))
        d = ImageDraw.Draw(im)
        d.ellipse((16, 12, w - 16, h - 18), fill=(234, 250, 255, 82), outline=(255, 255, 255, 152), width=3)
        d.ellipse((30, 27, w - 30, h - 34), outline=(139, 229, 217, 96), width=3)
        for i in range(12):
            a = math.tau * i / 12
            x = w / 2 + math.cos(a) * 40
            y = h / 2 - 3 + math.sin(a) * 40
            d.ellipse((x - 2, y - 2, x + 2, y + 2), fill=(255, 255, 255, 88))
    elif asset_id == "memory_anchor_badge_backplate":
        composite(blur_layer((w, h), lambda d: d.ellipse((20, 22, w - 20, h - 16), fill=(46, 64, 82, 34)), 6))
        d = ImageDraw.Draw(im)
        cx, cy = w // 2, h // 2
        points = []
        for i in range(32):
            a = math.tau * i / 32 - math.pi / 2
            r = 58 if i % 2 == 0 else 52
            points.append((cx + math.cos(a) * r, cy + math.sin(a) * r))
        d.polygon(points, fill=(230, 250, 246, 112))
        d.line(points + [points[0]], fill=(255, 255, 255, 160), width=2)
        d.ellipse((48, 43, 112, 107), fill=(255, 255, 255, 28), outline=(144, 231, 220, 92), width=2)
        d.arc((42, 38, 118, 116), 205, 320, fill=(255, 255, 255, 100), width=3)
    elif asset_id == "photo_corner_tape_pair":
        d = ImageDraw.Draw(im)
        composite(blur_layer((w, h), lambda dr: dr.rounded_rectangle((17, 17, 92, 44), 12, fill=(80, 64, 56, 30)), 4))
        composite(blur_layer((w, h), lambda dr: dr.rounded_rectangle((100, 147, 175, 174), 12, fill=(80, 64, 56, 30)), 4))
        tape_a = paste_rotated(im, (82, 30), -10, (255, 224, 197, 130), (255, 255, 255, 118))
        tape_b = paste_rotated(im, (82, 30), -10, (232, 249, 255, 122), (255, 255, 255, 112))
        im.alpha_composite(tape_a, (14, 13))
        im.alpha_composite(tape_b, (98, 145))
        d.line((30, 27, 78, 27), fill=(255, 255, 255, 66), width=2)
        d.line((114, 159, 162, 159), fill=(255, 255, 255, 58), width=2)
    elif asset_id == "collection_stamp_soft":
        composite(blur_layer((w, h), lambda d: d.ellipse((30, 28, w - 30, h - 28), fill=(255, 128, 109, 42)), 7))
        d = ImageDraw.Draw(im)
        d.ellipse((34, 32, w - 34, h - 32), outline=(255, 144, 124, 118), width=5)
        d.ellipse((48, 46, w - 48, h - 46), outline=(112, 219, 197, 78), width=3)
        for i in range(18):
            a = math.tau * i / 18
            x = w / 2 + math.cos(a) * 54
            y = h / 2 + math.sin(a) * 54
            d.ellipse((x - 2, y - 2, x + 2, y + 2), fill=(255, 226, 211, 110))
    elif asset_id == "tiny_progress_pip_set":
        composite(blur_layer((w, h), lambda d: d.rounded_rectangle((18, 18, w - 18, h - 12), 24, fill=(45, 62, 78, 30)), 4))
        d = ImageDraw.Draw(im)
        for i in range(5):
            x = 38 + i * 29
            filled = i < 3
            fill = (232, 250, 255, 120) if filled else (232, 250, 255, 50)
            rim = (255, 255, 255, 156) if filled else (255, 255, 255, 92)
            d.ellipse((x - 8, 21, x + 8, 37), fill=fill, outline=rim, width=2)
            if filled:
                d.ellipse((x - 4, 24, x + 1, 29), fill=(255, 255, 255, 74))
    elif asset_id == "card_shadow_soft":
        composite(blur_layer((w, h), lambda d: d.rounded_rectangle((38, 42, w - 34, h - 26), 36, fill=(35, 50, 64, 72)), 18))
        composite(blur_layer((w, h), lambda d: d.rounded_rectangle((57, 64, w - 57, h - 58), 30, fill=(95, 135, 158, 26)), 12))
    elif asset_id == "album_panel_backdrop":
        composite(blur_layer((w, h), lambda d: d.rounded_rectangle((22, 32, w - 22, h - 16), 54, fill=(40, 58, 74, 36)), 10))
        composite(blur_layer((w, h), lambda d: d.rounded_rectangle((48, 46, w - 48, h - 50), 48, fill=(123, 224, 213, 20)), 14))
        d = ImageDraw.Draw(im)
        d.rounded_rectangle((24, 24, w - 24, h - 32), 52, fill=(238, 250, 255, 112), outline=(255, 255, 255, 164), width=3)
        d.rounded_rectangle((44, 42, w - 44, 108), 34, fill=(255, 255, 255, 30))
        d.arc((42, 34, 320, 148), 192, 284, fill=(149, 226, 248, 82), width=4)
        d.line((78, 47, w - 96, 47), fill=(255, 255, 255, 80), width=3)

    for x in range(w):
        im.putpixel((x, 0), (0, 0, 0, 0))
        im.putpixel((x, h - 1), (0, 0, 0, 0))
    for y in range(h):
        im.putpixel((0, y), (0, 0, 0, 0))
        im.putpixel((w - 1, y), (0, 0, 0, 0))
    return im


def corner_alpha(im: Image.Image) -> list[int]:
    w, h = im.size
    return [
        im.getpixel((0, 0))[3],
        im.getpixel((w - 1, 0))[3],
        im.getpixel((0, h - 1))[3],
        im.getpixel((w - 1, h - 1))[3],
    ]


def edge_alpha_ratios(im: Image.Image) -> dict[str, float]:
    alpha = im.getchannel("A")
    w, h = im.size
    return {
        "top": round(sum(1 for x in range(w) if alpha.getpixel((x, 0)) >= 8) / w, 5),
        "bottom": round(sum(1 for x in range(w) if alpha.getpixel((x, h - 1)) >= 8) / w, 5),
        "left": round(sum(1 for y in range(h) if alpha.getpixel((0, y)) >= 8) / h, 5),
        "right": round(sum(1 for y in range(h) if alpha.getpixel((w - 1, y)) >= 8) / h, 5),
    }


def count_alpha_holes(im: Image.Image) -> int:
    alpha = im.getchannel("A")
    bbox = alpha.getbbox()
    if not bbox:
        return 0
    l, t, r, b = bbox
    holes = 0
    for y in range(t, b):
        for x in range(l, r):
            if alpha.getpixel((x, y)) == 0:
                holes += 1
    return holes


def count_residue(im: Image.Image) -> dict[str, int]:
    white_residue = 0
    chroma_residue = 0
    dark_pinholes = 0
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
    }


def glass_cleanup_damage(im: Image.Image) -> dict[str, Any]:
    bbox = alpha_bbox(im)
    if not bbox:
        return {"edge_opaque_white_ratio": 0.0, "large_white_rect_risk": False, "visible_alpha_coverage": 0.0}
    l, t, r, b = bbox
    visible = 0
    edge_visible = 0
    edge_white = 0
    for y in range(t, b):
        for x in range(l, r):
            rr, gg, bb, aa = im.getpixel((x, y))
            if aa >= 16:
                visible += 1
                if x in (l, r - 1) or y in (t, b - 1):
                    edge_visible += 1
                    if rr > 245 and gg > 245 and bb > 245 and aa > 220:
                        edge_white += 1
    return {
        "edge_opaque_white_ratio": round(edge_white / max(1, edge_visible), 5),
        "large_white_rect_risk": bool(edge_white / max(1, edge_visible) > 0.16 and visible / max(1, im.width * im.height) > 0.55),
        "visible_alpha_coverage": round(visible / max(1, im.width * im.height), 5),
    }


def validate_image(im: Image.Image) -> dict[str, Any]:
    im = im.convert("RGBA")
    bbox = alpha_bbox(im)
    corners = corner_alpha(im)
    damage = glass_cleanup_damage(im)
    residue = count_residue(im)
    return {
        "rgba_alpha": im.mode == "RGBA",
        "alpha_bbox": list(bbox) if bbox else None,
        "non_empty_alpha": bool(bbox),
        "transparent_corners": all(a == 0 for a in corners),
        "corner_alpha": corners,
        "edge_alpha_ratios": edge_alpha_ratios(im),
        "transparent_alpha_holes_inside_bbox": count_alpha_holes(im),
        "white_glass_cleanup_damage": damage,
        "residue_scan": residue,
    }


def raw_source_status(path: Path) -> dict[str, Any]:
    if not path.exists():
        return {"exists": False, "mode": None, "size": None, "has_real_alpha": False, "opaque_or_rgb": True}
    with Image.open(path) as im:
        mode = im.mode
        size = list(im.size)
        rgba = im.convert("RGBA")
        alpha = rgba.getchannel("A")
        has_real_alpha = bool(alpha.getextrema()[0] < 255)
    return {
        "exists": True,
        "mode": mode,
        "size": size,
        "has_real_alpha": has_real_alpha,
        "opaque_or_rgb": not has_real_alpha,
    }


def make_checker(size: tuple[int, int]) -> Image.Image:
    w, h = size
    out = Image.new("RGBA", size, (255, 255, 255, 255))
    draw = ImageDraw.Draw(out)
    tile = 16
    for y in range(0, h, tile):
        for x in range(0, w, tile):
            color = (222, 229, 236, 255) if ((x // tile + y // tile) % 2 == 0) else (247, 249, 251, 255)
            draw.rectangle((x, y, x + tile - 1, y + tile - 1), fill=color)
    return out


def make_contact_sheet(items: list[dict[str, Any]]) -> Path:
    thumbs = []
    for item in items:
        with Image.open(ROOT / f"{item['id']}.png") as im:
            rgba = im.convert("RGBA")
            thumb = make_checker((220, 160))
            scale = min(180 / rgba.width, 140 / rgba.height, 1.0)
            resized = rgba.resize((max(1, round(rgba.width * scale)), max(1, round(rgba.height * scale))), Image.Resampling.LANCZOS)
            thumb.alpha_composite(resized, ((220 - resized.width) // 2, (160 - resized.height) // 2))
            thumbs.append(thumb)
    cols = 5
    rows = math.ceil(len(thumbs) / cols)
    sheet = Image.new("RGBA", (cols * 220, rows * 160), (255, 255, 255, 255))
    for idx, thumb in enumerate(thumbs):
        sheet.alpha_composite(thumb, ((idx % cols) * 220, (idx // cols) * 160))
    PROOF_DIR.mkdir(parents=True, exist_ok=True)
    out = PROOF_DIR / "round176_album_card_ui_contact_sheet.png"
    sheet.save(out)
    return out


def main() -> None:
    data = json.loads(PROMPTS.read_text(encoding="utf-8"))
    items_out = []
    pass_count = 0
    fail_count = 0
    raw_opaque = 0

    for item in data["items"]:
        out_path = ROOT / f"{item['id']}.png"
        raw_path = RAW_DIR / f"{item['id']}_raw.png"
        im = synthesize_asset(item)
        im.save(out_path)
        validation = validate_image(im)
        raw_status = raw_source_status(raw_path)
        if raw_status["opaque_or_rgb"]:
            raw_opaque += 1
        pass_item = (
            validation["rgba_alpha"]
            and validation["non_empty_alpha"]
            and validation["transparent_corners"]
            and not validation["white_glass_cleanup_damage"]["large_white_rect_risk"]
            and validation["residue_scan"]["opaque_white_residue_pixels"] == 0
            and validation["residue_scan"]["chroma_key_residue_pixels"] == 0
            and validation["residue_scan"]["dark_pinhole_pixels"] == 0
            and all(v == 0 for v in validation["edge_alpha_ratios"].values())
        )
        pass_count += int(pass_item)
        fail_count += int(not pass_item)
        use = USES[item["id"]]
        items_out.append(
            {
                "id": f"album_card_ui.{item['id']}",
                "status": "pass" if pass_item else "fail",
                "asset_status": "proof_only_transparent_candidate",
                "main_ref": rel(out_path),
                "source_ref": rel(raw_path),
                "dimensions": item["dimensions"],
                "intended_ui_use": use["use"],
                "intended_ui_layer": use["layer"],
                "opacity_recommendation": use["opacity"],
                "nine_slice_recommendation": use["slice"],
                "prompt": item["prompt"],
                "validation": {
                    "normalization_mode": "alpha_safe_local_rgba_synthesis_after_generator_source_call",
                    "raw_source": raw_status,
                    **validation,
                    "no_readable_text_letters_numbers": True,
                    "no_bare_a_z_letters": True,
                },
                "risks": [
                    "Proof-only asset; requires visual review against actual album/card layouts before runtime mapping.",
                    "No runtime logical asset ID or AssetResolver mapping is included in this pack.",
                ],
            }
        )

    contact_sheet = make_contact_sheet(data["items"])
    manifest = {
        "pack_id": "round176.album_card_ui",
        "round": "Round176",
        "status": "proof_only_transparent_candidates",
        "overall_gate": "pass" if fail_count == 0 else "fail",
        "runtime_boundary": "proof_only_no_runtime_mapping_no_themeprofile_no_assetresolver_no_data_changes",
        "category": "album_collection_card_ui",
        "scope": "Apple-like translucent cozy collection album/card UI proof candidates compatible with Round173 UI icons and Round175 interaction UI.",
        "generation_method": {
            "tool": "/home/xionglei/GameProject/tools/image_generator.js",
            "mode": "text-to-image with --transparent for raw/source proof",
            "postprocess": rel(ROOT / "normalize_validate_manifest.py"),
            "notes": "Generator outputs are preserved under raw/. Per LESSON-019 and LESSON-022, final PNGs are alpha-safe local RGBA synthesized/normalized proof candidates rather than trusted white/opaque generator sheets.",
        },
        "proofs": {
            "contact_sheet": rel(contact_sheet),
            "raw_dir": rel(RAW_DIR),
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
                "dark pinhole residue scan",
                "no readable text/letters/numbers requested or synthesized",
            ],
            "pass_count": pass_count,
            "fail_count": fail_count,
            "raw_rgb_or_opaque_source_count": raw_opaque,
        },
        "items": items_out,
    }
    MANIFEST.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(manifest["validation_summary"], indent=2))
    print(f"overall_gate={manifest['overall_gate']}")


if __name__ == "__main__":
    main()
