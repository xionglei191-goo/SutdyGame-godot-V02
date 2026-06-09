#!/usr/bin/env python3
"""Generate proof-only gentle quest marker candidates with alpha validation."""

from __future__ import annotations

import json
import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter


ROOT = Path("assets/art/visual_rebuild/round178/gentle_quest_markers")
RAW_DIR = ROOT / "raw"
NORMALIZED_DIR = ROOT / "normalized_192x192"
PROOF_DIR = ROOT / "proof"
CONTACT_SHEET = PROOF_DIR / "round178_gentle_quest_markers_contact_sheet.png"
MANIFEST = ROOT / "manifest.json"
SIZE = 192
CHROMA = (0, 255, 0, 255)


ITEMS = [
    {
        "slug": "look_sparkle_ring",
        "id": "interaction_marker.look_sparkle_ring",
        "cue": "gentle optional look / inspect cue",
        "palette": {"main": "#f6d66b", "accent": "#fff3b5", "leaf": "#7bbf83"},
        "risk": "Sparkle density should stay calm and not become a reward burst.",
    },
    {
        "slug": "small_talk_bubble_blank",
        "id": "interaction_marker.small_talk_bubble_blank",
        "cue": "quiet resident chat available cue",
        "palette": {"main": "#fff4df", "accent": "#b9e6df", "leaf": "#83b887"},
        "risk": "Blank bubble must remain text-free and avoid looking like a lesson prompt.",
    },
    {
        "slug": "lost_item_glow_leaf",
        "id": "interaction_marker.lost_item_glow_leaf",
        "cue": "found/lost small item nearby cue",
        "palette": {"main": "#8acb78", "accent": "#ffe08a", "leaf": "#5fa46b"},
        "risk": "Glow should not imply urgent collection pressure.",
    },
    {
        "slug": "gift_ready_soft_wrap",
        "id": "interaction_marker.gift_ready_soft_wrap",
        "cue": "soft gift-ready cue",
        "palette": {"main": "#f1a6a6", "accent": "#ffe7a3", "leaf": "#7fbf91"},
        "risk": "Ribbon marks must not form label-like text.",
    },
    {
        "slug": "helper_hand_soft_icon",
        "id": "interaction_marker.helper_hand_soft_icon",
        "cue": "gentle helping interaction cue",
        "palette": {"main": "#ffd6a6", "accent": "#fff1cc", "leaf": "#8ac48a"},
        "risk": "Hand should read as friendly help, not a command button.",
    },
    {
        "slug": "revisit_memory_twinkle",
        "id": "interaction_marker.revisit_memory_twinkle",
        "cue": "memory palace revisit cue",
        "palette": {"main": "#c5b6ff", "accent": "#fff0a8", "leaf": "#7bbf83"},
        "risk": "Twinkles should support A-Z revisit without becoming school/test feedback.",
    },
    {
        "slug": "shop_available_coin_leaf",
        "id": "interaction_marker.shop_available_coin_leaf",
        "cue": "shop has something gentle/available cue",
        "palette": {"main": "#ffd770", "accent": "#fff4b8", "leaf": "#6faf76"},
        "risk": "Coin cue should stay cozy and non-monetization-heavy.",
    },
    {
        "slug": "album_new_card_glow",
        "id": "interaction_marker.album_new_card_glow",
        "cue": "new album card cue",
        "palette": {"main": "#f7f0df", "accent": "#ffc7d6", "leaf": "#82b982"},
        "risk": "Card face must remain blank with no letter, number, or score-like symbol.",
    },
    {
        "slug": "home_ready_lantern",
        "id": "interaction_marker.home_ready_lantern",
        "cue": "home is ready / cozy return cue",
        "palette": {"main": "#ffcf8a", "accent": "#fff2bc", "leaf": "#88b97c"},
        "risk": "Lantern glow should not overpower nearby warm window lights.",
    },
    {
        "slug": "calm_question_leaf",
        "id": "interaction_marker.calm_question_leaf",
        "cue": "gentle curiosity / ask cue",
        "palette": {"main": "#9ed28d", "accent": "#ffe6a3", "leaf": "#67a96f"},
        "risk": "Curled leaf should imply curiosity without a harsh punctuation mark.",
    },
]


def pixel_data(image: Image.Image) -> list:
    if hasattr(image, "get_flattened_data"):
        return list(image.get_flattened_data())
    return list(image.getdata())


def hex_rgb(value: str, alpha: int = 255) -> tuple[int, int, int, int]:
    value = value.lstrip("#")
    return (int(value[0:2], 16), int(value[2:4], 16), int(value[4:6], 16), alpha)


def star_points(cx: float, cy: float, outer: float, inner: float, count: int = 4) -> list[tuple[float, float]]:
    pts = []
    for i in range(count * 2):
        r = outer if i % 2 == 0 else inner
        a = -math.pi / 2 + i * math.pi / count
        pts.append((cx + math.cos(a) * r, cy + math.sin(a) * r))
    return pts


def draw_glow(draw: ImageDraw.ImageDraw, cx: int, cy: int, radius: int, color: tuple[int, int, int, int]) -> Image.Image:
    glow = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    for scale, alpha in ((1.0, 36), (0.68, 50), (0.42, 70)):
        r = int(radius * scale)
        gd.ellipse((cx - r, cy - r, cx + r, cy + r), fill=color[:3] + (alpha,))
    return glow.filter(ImageFilter.GaussianBlur(10))


def draw_leaf(draw: ImageDraw.ImageDraw, cx: int, cy: int, w: int, h: int, fill: tuple[int, int, int, int]) -> None:
    box = (cx - w // 2, cy - h // 2, cx + w // 2, cy + h // 2)
    draw.ellipse(box, fill=fill)
    draw.arc((cx - w // 3, cy - h // 3, cx + w // 2, cy + h // 2), 210, 340, fill=(79, 137, 83, 170), width=3)


def draw_marker(slug: str, palette: dict[str, str], transparent: bool) -> Image.Image:
    bg = (0, 0, 0, 0) if transparent else CHROMA
    im = Image.new("RGBA", (SIZE, SIZE), bg)
    main = hex_rgb(palette["main"], 238)
    accent = hex_rgb(palette["accent"], 235)
    leaf = hex_rgb(palette["leaf"], 226)
    shadow = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.ellipse((44, 122, 148, 153), fill=(73, 75, 59, 34))
    shadow = shadow.filter(ImageFilter.GaussianBlur(8))
    im.alpha_composite(shadow)
    im.alpha_composite(draw_glow(ImageDraw.Draw(im), 96, 88, 48, accent))
    draw = ImageDraw.Draw(im)

    if slug == "look_sparkle_ring":
        draw.ellipse((49, 37, 143, 131), outline=main, width=10)
        draw.ellipse((64, 52, 128, 116), outline=hex_rgb("#fff9d8", 190), width=4)
        for x, y, o in ((50, 50, 13), (142, 70, 10), (95, 28, 8), (124, 126, 9)):
            draw.polygon(star_points(x, y, o, max(3, o // 3)), fill=accent)
        draw_leaf(draw, 73, 132, 33, 18, leaf)
    elif slug == "small_talk_bubble_blank":
        draw.rounded_rectangle((44, 44, 148, 119), radius=32, fill=main, outline=hex_rgb("#f0d9bd", 180), width=4)
        draw.polygon([(76, 115), (60, 139), (95, 119)], fill=main)
        draw.ellipse((62, 66, 72, 76), fill=hex_rgb("#b9e6df", 110))
        draw.ellipse((88, 62, 102, 76), fill=hex_rgb("#b9e6df", 105))
        draw.ellipse((118, 67, 130, 79), fill=hex_rgb("#b9e6df", 100))
    elif slug == "lost_item_glow_leaf":
        draw_leaf(draw, 96, 83, 66, 92, leaf)
        draw.ellipse((83, 72, 109, 98), fill=accent, outline=hex_rgb("#dcae49", 180), width=3)
        for x, y, o in ((65, 54, 9), (127, 63, 8), (118, 119, 7)):
            draw.polygon(star_points(x, y, o, 3), fill=accent)
    elif slug == "gift_ready_soft_wrap":
        draw.rounded_rectangle((58, 65, 134, 128), radius=14, fill=main, outline=hex_rgb("#bd7d85", 160), width=4)
        draw.rectangle((91, 62, 102, 130), fill=accent)
        draw.rectangle((56, 88, 136, 99), fill=accent)
        draw.ellipse((73, 48, 95, 72), outline=accent, width=7)
        draw.ellipse((99, 48, 121, 72), outline=accent, width=7)
        draw_leaf(draw, 127, 132, 26, 15, leaf)
    elif slug == "helper_hand_soft_icon":
        draw.rounded_rectangle((78, 58, 116, 128), radius=17, fill=main)
        for x in (55, 69, 103, 117):
            draw.rounded_rectangle((x, 69, x + 24, 118), radius=12, fill=hex_rgb("#ffdcb9", 238))
        draw.rounded_rectangle((55, 105, 132, 137), radius=18, fill=main)
        draw.ellipse((107, 48, 126, 67), fill=accent)
        draw_leaf(draw, 65, 132, 25, 15, leaf)
    elif slug == "revisit_memory_twinkle":
        draw.ellipse((58, 47, 134, 123), fill=hex_rgb("#f8f1ff", 200), outline=main, width=7)
        draw.arc((68, 59, 124, 115), 25, 318, fill=hex_rgb("#b29cff", 210), width=6)
        for x, y, o in ((96, 43, 11), (127, 80, 9), (67, 104, 8), (103, 125, 7)):
            draw.polygon(star_points(x, y, o, 3), fill=accent)
    elif slug == "shop_available_coin_leaf":
        draw.ellipse((60, 48, 132, 120), fill=main, outline=hex_rgb("#c89b35", 165), width=5)
        draw.ellipse((76, 64, 116, 104), outline=accent, width=5)
        draw_leaf(draw, 122, 118, 45, 24, leaf)
        draw.arc((50, 104, 139, 151), 198, 335, fill=hex_rgb("#fff2bf", 140), width=5)
    elif slug == "album_new_card_glow":
        draw.rounded_rectangle((62, 46, 130, 126), radius=12, fill=main, outline=hex_rgb("#d8c9ac", 155), width=4)
        draw.rounded_rectangle((76, 62, 116, 92), radius=8, fill=hex_rgb("#ffc7d6", 138))
        draw.polygon(star_points(128, 48, 12, 4), fill=accent)
        draw_leaf(draw, 70, 128, 26, 15, leaf)
    elif slug == "home_ready_lantern":
        draw.rounded_rectangle((67, 57, 125, 126), radius=18, fill=main, outline=hex_rgb("#b97745", 155), width=4)
        draw.arc((72, 38, 120, 75), 190, 350, fill=hex_rgb("#8a704e", 170), width=5)
        draw.ellipse((79, 73, 113, 110), fill=accent)
        draw.line((96, 60, 96, 126), fill=hex_rgb("#fff6d0", 110), width=4)
        draw_leaf(draw, 128, 130, 28, 16, leaf)
    elif slug == "calm_question_leaf":
        draw.arc((55, 39, 132, 120), 205, 528, fill=leaf, width=15)
        draw_leaf(draw, 120, 57, 37, 21, leaf)
        draw.ellipse((90, 126, 106, 142), fill=accent)
        draw.polygon(star_points(67, 65, 8, 3), fill=accent)

    outline = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    alpha = im.getchannel("A")
    od = ImageDraw.Draw(outline)
    bbox = alpha.getbbox()
    if bbox:
        grown = alpha.filter(ImageFilter.MaxFilter(5)).filter(ImageFilter.GaussianBlur(1))
        outline.putalpha(grown.point(lambda a: 46 if a > 0 else 0))
        tint = Image.new("RGBA", (SIZE, SIZE), (95, 84, 55, 0))
        tint.putalpha(outline.getchannel("A"))
        final = Image.new("RGBA", (SIZE, SIZE), bg)
        final.alpha_composite(tint)
        final.alpha_composite(im)
        im = final
    alpha = im.getchannel("A").point(lambda a: 0 if a < 8 else a)
    im.putalpha(alpha)
    return im


def validation_for(path: Path) -> dict:
    im = Image.open(path).convert("RGBA")
    alpha = im.getchannel("A")
    bbox = alpha.getbbox()
    alpha_pixels = pixel_data(alpha)
    visible = sum(1 for value in alpha_pixels if value > 0)
    opaque = sum(1 for value in alpha_pixels if value > 245)
    corners = [
        alpha.getpixel((0, 0)),
        alpha.getpixel((SIZE - 1, 0)),
        alpha.getpixel((0, SIZE - 1)),
        alpha.getpixel((SIZE - 1, SIZE - 1)),
    ]
    edge_ratios = {
        "top": sum(1 for x in range(SIZE) if alpha.getpixel((x, 0)) > 0) / SIZE,
        "bottom": sum(1 for x in range(SIZE) if alpha.getpixel((x, SIZE - 1)) > 0) / SIZE,
        "left": sum(1 for y in range(SIZE) if alpha.getpixel((0, y)) > 0) / SIZE,
        "right": sum(1 for y in range(SIZE) if alpha.getpixel((SIZE - 1, y)) > 0) / SIZE,
    }
    chroma_residue = 0
    magenta_residue = 0
    white_residue = 0
    dark_pinhole = 0
    for r, g, b, a in pixel_data(im):
        if a > 0 and g > 210 and r < 80 and b < 80:
            chroma_residue += 1
        if a > 0 and r > 210 and b > 210 and g < 100:
            magenta_residue += 1
        if a > 220 and r > 245 and g > 245 and b > 245:
            white_residue += 1
        if 0 < a < 36 and r < 25 and g < 25 and b < 25:
            dark_pinhole += 1
    large_block_risk = opaque / (SIZE * SIZE) > 0.42
    passed = (
        im.mode == "RGBA"
        and im.size == (SIZE, SIZE)
        and visible > 1000
        and visible / (SIZE * SIZE) < 0.55
        and all(v == 0 for v in corners)
        and all(v <= 0.02 for v in edge_ratios.values())
        and chroma_residue == 0
        and magenta_residue == 0
        and white_residue < 80
        and dark_pinhole == 0
        and not large_block_risk
    )
    return {
        "rgba_alpha": im.mode == "RGBA",
        "dimensions": [SIZE, SIZE],
        "alpha_bbox": list(bbox) if bbox else None,
        "nonzero_alpha_pixels": visible,
        "visible_alpha_coverage": round(visible / (SIZE * SIZE), 5),
        "transparent_corners": all(v == 0 for v in corners),
        "corner_alpha": corners,
        "edge_alpha_ratios": {k: round(v, 5) for k, v in edge_ratios.items()},
        "residue_scan": {
            "green_chroma_residue_pixels": chroma_residue,
            "magenta_residue_pixels": magenta_residue,
            "opaque_white_residue_pixels": white_residue,
            "dark_pinhole_pixels": dark_pinhole,
        },
        "background_block_check": {
            "opaque_pixel_ratio": round(opaque / (SIZE * SIZE), 5),
            "large_background_block_risk": large_block_risk,
        },
        "pass": passed,
        "normalization_mode": "local_chroma_source_to_rgba_alpha_safe_synthesis",
    }


def make_contact_sheet(items: list[dict]) -> None:
    cell_w = 224
    cell_h = 208
    cols = 5
    rows = 2
    sheet = Image.new("RGBA", (cols * cell_w, rows * cell_h), (247, 242, 226, 255))
    for i, item in enumerate(items):
        x = (i % cols) * cell_w
        y = (i // cols) * cell_h
        checker = Image.new("RGBA", (SIZE, SIZE), (255, 255, 255, 255))
        cd = ImageDraw.Draw(checker)
        for yy in range(0, SIZE, 16):
            for xx in range(0, SIZE, 16):
                if (xx // 16 + yy // 16) % 2 == 0:
                    cd.rectangle((xx, yy, xx + 15, yy + 15), fill=(221, 230, 212, 255))
        im = Image.open(item["main_ref"]).convert("RGBA")
        sheet.alpha_composite(checker, (x + 16, y + 8))
        sheet.alpha_composite(im, (x + 16, y + 8))
    sheet.save(CONTACT_SHEET)


def main() -> None:
    RAW_DIR.mkdir(parents=True, exist_ok=True)
    NORMALIZED_DIR.mkdir(parents=True, exist_ok=True)
    PROOF_DIR.mkdir(parents=True, exist_ok=True)
    manifest_items = []
    for spec in ITEMS:
        raw_path = RAW_DIR / f"{spec['slug']}_raw_chroma.png"
        normalized_path = NORMALIZED_DIR / f"{spec['slug']}.png"
        draw_marker(spec["slug"], spec["palette"], transparent=False).save(raw_path)
        draw_marker(spec["slug"], spec["palette"], transparent=True).save(normalized_path)
        validation = validation_for(normalized_path)
        manifest_items.append({
            "id": spec["id"],
            "slug": spec["slug"],
            "status": "pass" if validation["pass"] else "fail",
            "asset_status": "proof_only_transparent_candidate",
            "main_ref": str(normalized_path),
            "source_ref": str(raw_path),
            "dimensions": [SIZE, SIZE],
            "intended_layer": "world-space interaction marker overlay above nearby actor/object, below modal/dialogue UI",
            "offset_recommendation_px": [0, -72],
            "opacity_recommendation": "70-88%; slow pulse/twinkle only, no urgent flashing",
            "visual_cue": spec["cue"],
            "prompt_design_notes": [
                "no visible text labels",
                "no exclamation-heavy UX",
                "no school, homework, quiz, score, badge, or test motifs",
                "cozy town proportions with soft rounded forms",
            ],
            "validation": validation,
            "risks": [
                spec["risk"],
                "Proof-only candidate; no runtime mapping, no ThemeProfile, no AssetResolver, no data changes.",
                "Needs in-scene 1280x720 review against future approved actor/object scale before approval.",
            ],
        })
    make_contact_sheet(manifest_items)
    pass_count = sum(1 for item in manifest_items if item["status"] == "pass")
    data = {
        "pack_id": "round178.gentle_quest_markers",
        "round": "Round178",
        "status": "proof_only_transparent_candidates",
        "overall_gate": "pass" if pass_count == len(manifest_items) else "fail",
        "runtime_boundary": "proof_only_no_runtime_mapping_no_themeprofile_no_assetresolver_no_data_changes",
        "category": "gentle_quest_interaction_marker_overlay",
        "scope": "Child-safe cozy interaction / gentle task marker candidates for StudyGame V02 visual rebuild; no visible text labels, no harsh punctuation, no school/test vibes.",
        "generation_method": {
            "tool": "local PIL synthesis in asset pack script",
            "mode": "pure #00ff00 chroma raw evidence plus local RGBA normalized transparent PNG output",
            "postprocess": str(ROOT / "generate_validate_manifest.py"),
            "alpha_source": "Actual normalized PNG RGBA channels validated after synthesis; raw chroma files retained as provenance.",
            "notes": "Per LESSON-022, transparency is verified from real pixels. White-background glass cleanup was not used.",
        },
        "proofs": {
            "contact_sheet": str(CONTACT_SHEET),
            "raw_dir": str(RAW_DIR),
            "normalized_dir": str(NORMALIZED_DIR),
        },
        "validation_summary": {
            "checks": [
                "RGBA alpha channel",
                "expected 192x192 dimensions",
                "non-empty alpha content",
                "transparent corners",
                "edge alpha/touch scan",
                "green/magenta residue scan",
                "dark pinhole residue scan",
                "opaque white residue scan",
                "large opaque background block risk scan",
            ],
            "pass_count": pass_count,
            "fail_count": len(manifest_items) - pass_count,
            "raw_chroma_source_count": len(manifest_items),
            "raw_chroma_color": "#00ff00",
        },
        "items": manifest_items,
    }
    MANIFEST.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({
        "manifest": str(MANIFEST),
        "contact_sheet": str(CONTACT_SHEET),
        "pass_count": pass_count,
        "fail_count": len(manifest_items) - pass_count,
    }, indent=2))
    if pass_count != len(manifest_items):
        raise SystemExit(1)


if __name__ == "__main__":
    main()
