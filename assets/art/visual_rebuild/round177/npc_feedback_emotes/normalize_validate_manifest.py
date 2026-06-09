#!/usr/bin/env python3
from __future__ import annotations

import json
import math
from pathlib import Path
from typing import Any

from PIL import Image, ImageDraw, ImageFilter, ImageFont


ROOT = Path(__file__).resolve().parent
RAW = ROOT / "raw"
OUT = ROOT / "normalized_192x192"
PROOF = ROOT / "proof"
MANIFEST = ROOT / "manifest.json"
CANVAS = (192, 192)


ITEMS: list[dict[str, Any]] = [
    {
        "slug": "friendly_hello_bubble",
        "id": "npc_feedback_emote.friendly_hello_bubble",
        "icon": "hand",
        "prompt": "single overhead NPC feedback emote bubble, friendly hello feeling, tiny open hand wave icon made of rounded shapes, Apple-like translucent glass softness, no readable text, no letters, no numbers, no punctuation marks",
        "layer": "world-space overhead feedback above NPC head, below dialogue/modal UI and above actor body",
        "offset": [0, -94],
        "opacity": "78-92% bubble alpha; icon 80-95%; animate fade/float 0.6-1.0s",
        "risk": "Hand silhouette should remain abstract enough not to look like a command button.",
    },
    {
        "slug": "gentle_need_help_bubble",
        "id": "npc_feedback_emote.gentle_need_help_bubble",
        "icon": "hands",
        "prompt": "single overhead NPC feedback emote bubble, gentle need-help feeling, two soft helping hands and a glow dot, no question mark, no exclamation mark, no readable text",
        "layer": "world-space overhead need/help cue above resident, below dialogue/modal UI",
        "offset": [0, -96],
        "opacity": "72-88%; avoid urgent flashing, use slow pulse only",
        "risk": "Could read as task pressure if animated too strongly; keep calm and optional.",
    },
    {
        "slug": "gift_thought_bubble",
        "id": "npc_feedback_emote.gift_thought_bubble",
        "icon": "gift",
        "prompt": "single overhead NPC feedback thought bubble, gift thought, small wrapped gift box with ribbon loops only, no labels, no readable text, no letters, no numbers",
        "layer": "world-space thought cue above NPC, below dialogue/modal UI",
        "offset": [0, -98],
        "opacity": "76-90%; can bob gently when NPC has a gift-related thought",
        "risk": "Gift shape must stay text-free; avoid label-like ribbon marks.",
    },
    {
        "slug": "sunny_happy_bubble",
        "id": "npc_feedback_emote.sunny_happy_bubble",
        "icon": "sun",
        "prompt": "single overhead NPC feedback emote bubble, sunny happy mood, smiling sun-like circle with rounded rays, child-friendly, no readable text, no letters, no numbers",
        "layer": "world-space mood cue above NPC/Sunny, compatible with Round174 weather FX",
        "offset": [0, -94],
        "opacity": "72-88%; do not overpower separate weather sparkle layers",
        "risk": "Sun icon may overlap with weather state semantics; review in rainy/sunny scenes.",
    },
    {
        "slug": "sleepy_soft_bubble",
        "id": "npc_feedback_emote.sleepy_soft_bubble",
        "icon": "moon",
        "prompt": "single overhead NPC feedback emote bubble, sleepy soft mood, crescent moon and soft floating dots only, no Z letters, no readable text, no letters, no numbers",
        "layer": "world-space overhead status cue above NPC/pet, below dialogue/modal UI",
        "offset": [0, -94],
        "opacity": "68-84%; slow fade, no attention-grabbing bounce",
        "risk": "Dots should not form ellipsis punctuation; keep them decorative and offset.",
    },
    {
        "slug": "hungry_snack_bubble",
        "id": "npc_feedback_emote.hungry_snack_bubble",
        "icon": "snack",
        "prompt": "single overhead NPC feedback thought bubble, hungry snack thought, small snack bowl and tiny fruit shapes, no labels, no readable text, no letters, no numbers",
        "layer": "world-space thought cue above NPC/pet, below dialogue/modal UI",
        "offset": [0, -96],
        "opacity": "74-90%; use as gentle want state, not a warning",
        "risk": "Snack shapes may need child-safety review for allergy/food specificity before final mapping.",
    },
    {
        "slug": "friendship_heart_bubble",
        "id": "npc_feedback_emote.friendship_heart_bubble",
        "icon": "heart",
        "prompt": "single overhead NPC feedback emote bubble, friendship feeling, two overlapping soft heart shapes with gentle glow, no readable text, no letters, no numbers",
        "layer": "world-space relationship feedback above NPC, below dialogue/modal UI and above actor body",
        "offset": [0, -94],
        "opacity": "70-88%; can combine with Round175 friendship glow at lower opacity",
        "risk": "May duplicate Round175 friendship_heart_glow; treat as overhead cue variant only.",
    },
    {
        "slug": "weather_umbrella_bubble",
        "id": "npc_feedback_emote.weather_umbrella_bubble",
        "icon": "umbrella",
        "prompt": "single overhead NPC feedback thought bubble, weather rain thought, small rounded umbrella and two soft raindrops, no readable text, no letters, no numbers, no punctuation marks",
        "layer": "world-space weather thought above NPC, above actor and below weather foreground overlays",
        "offset": [0, -98],
        "opacity": "72-88%; keep under strong rain overlays if present",
        "risk": "Raindrops must not be mistaken for collectible item drops.",
    },
    {
        "slug": "found_item_spark_bubble",
        "id": "npc_feedback_emote.found_item_spark_bubble",
        "icon": "spark",
        "prompt": "single overhead NPC feedback emote bubble, found item feeling, tiny leaf-shaped token with abstract sparkles, no star punctuation, no readable text, no letters, no numbers",
        "layer": "world-space discovery cue above NPC/resource helper, below dialogue/modal UI",
        "offset": [0, -96],
        "opacity": "74-90%; sparkles can twinkle separately but stay soft",
        "risk": "Sparkles must stay abstract and not become harsh starburst punctuation.",
    },
    {
        "slug": "calm_question_bubble",
        "id": "npc_feedback_emote.calm_question_bubble",
        "icon": "spiral",
        "prompt": "single overhead NPC feedback emote bubble, calm curiosity feeling, soft spiral and small scattered dots, no question mark, no readable text, no letters, no numbers",
        "layer": "world-space gentle curiosity cue above NPC, below dialogue/modal UI",
        "offset": [0, -94],
        "opacity": "68-84%; avoid urgent shake or warning timing",
        "risk": "Spiral should read as curiosity, not dizziness; review with child-facing UX.",
    },
]


def rel(path: Path) -> str:
    return str(path.relative_to(Path.cwd()))


def font(size: int) -> ImageFont.ImageFont:
    for p in ("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",):
        if Path(p).exists():
            return ImageFont.truetype(p, size)
    return ImageFont.load_default()


def bubble_base() -> Image.Image:
    im = Image.new("RGBA", CANVAS, (0, 0, 0, 0))
    shadow = Image.new("RGBA", CANVAS, (0, 0, 0, 0))
    d = ImageDraw.Draw(shadow)
    d.ellipse((31, 24, 163, 142), fill=(42, 61, 74, 40))
    d.ellipse((55, 128, 75, 148), fill=(42, 61, 74, 30))
    shadow = shadow.filter(ImageFilter.GaussianBlur(8))
    im.alpha_composite(shadow)
    d = ImageDraw.Draw(im)
    d.ellipse((29, 20, 163, 140), fill=(238, 251, 255, 132), outline=(255, 255, 255, 184), width=3)
    d.ellipse((45, 34, 146, 96), fill=(255, 255, 255, 28))
    d.arc((45, 31, 148, 111), 198, 319, fill=(150, 229, 247, 88), width=3)
    d.ellipse((61, 126, 78, 142), fill=(238, 251, 255, 116), outline=(255, 255, 255, 146), width=2)
    d.ellipse((49, 142, 59, 152), fill=(238, 251, 255, 76), outline=(255, 255, 255, 102), width=1)
    return im


def heart_points(cx: float, cy: float, s: float) -> list[tuple[float, float]]:
    pts = []
    for i in range(80):
        t = math.tau * i / 80
        x = 16 * math.sin(t) ** 3
        y = -(13 * math.cos(t) - 5 * math.cos(2 * t) - 2 * math.cos(3 * t) - math.cos(4 * t))
        pts.append((cx + x * s, cy + y * s))
    return pts


def draw_icon(im: Image.Image, kind: str) -> None:
    d = ImageDraw.Draw(im, "RGBA")
    if kind == "hand":
        d.rounded_rectangle((84, 65, 101, 108), 8, fill=(255, 206, 154, 230), outline=(255, 244, 220, 180), width=2)
        for x, h in [(70, 29), (82, 38), (96, 35), (109, 27)]:
            d.rounded_rectangle((x, 55, x + 13, 55 + h), 7, fill=(255, 213, 164, 230), outline=(255, 247, 230, 150), width=1)
        d.ellipse((72, 82, 118, 119), fill=(255, 202, 148, 235), outline=(255, 247, 230, 150), width=2)
        d.arc((118, 48, 146, 76), 112, 252, fill=(115, 207, 226, 128), width=4)
    elif kind == "hands":
        d.rounded_rectangle((55, 80, 100, 104), 12, fill=(255, 207, 157, 226), outline=(255, 247, 230, 150), width=2)
        d.rounded_rectangle((93, 80, 138, 104), 12, fill=(255, 222, 172, 226), outline=(255, 247, 230, 150), width=2)
        d.ellipse((89, 59, 104, 74), fill=(128, 218, 205, 190))
    elif kind == "gift":
        d.rounded_rectangle((61, 69, 131, 116), 10, fill=(255, 168, 139, 230), outline=(255, 245, 231, 170), width=2)
        d.rectangle((90, 69, 102, 116), fill=(255, 229, 148, 220))
        d.rectangle((61, 84, 131, 96), fill=(255, 229, 148, 220))
        d.ellipse((70, 51, 96, 74), outline=(255, 229, 148, 220), width=6)
        d.ellipse((96, 51, 122, 74), outline=(255, 229, 148, 220), width=6)
    elif kind == "sun":
        for a in range(12):
            ang = math.tau * a / 12
            x1, y1 = 96 + math.cos(ang) * 38, 86 + math.sin(ang) * 38
            x2, y2 = 96 + math.cos(ang) * 48, 86 + math.sin(ang) * 48
            d.line((x1, y1, x2, y2), fill=(255, 212, 93, 188), width=6)
        d.ellipse((60, 50, 132, 122), fill=(255, 218, 105, 232), outline=(255, 248, 218, 175), width=3)
        d.arc((75, 79, 113, 106), 20, 160, fill=(236, 139, 95, 150), width=4)
    elif kind == "moon":
        d.ellipse((66, 48, 126, 108), fill=(167, 196, 245, 230), outline=(245, 250, 255, 165), width=2)
        d.ellipse((87, 39, 142, 101), fill=(238, 251, 255, 245))
        for x, y, r in [(62, 115, 4), (121, 65, 3), (132, 107, 5)]:
            d.ellipse((x-r, y-r, x+r, y+r), fill=(170, 220, 234, 150))
    elif kind == "snack":
        d.ellipse((61, 91, 132, 120), fill=(123, 205, 191, 230), outline=(245, 255, 250, 165), width=2)
        d.arc((62, 72, 132, 119), 0, 180, fill=(255, 231, 170, 210), width=16)
        for x, y, c in [(75, 70, (255, 174, 124, 230)), (96, 63, (255, 213, 116, 230)), (115, 72, (137, 212, 135, 230))]:
            d.ellipse((x-9, y-9, x+9, y+9), fill=c, outline=(255, 255, 245, 120), width=1)
    elif kind == "heart":
        d.polygon(heart_points(84, 87, 2.0), fill=(255, 128, 157, 225))
        d.polygon(heart_points(109, 87, 2.0), fill=(255, 176, 132, 210))
        d.arc((57, 45, 137, 122), 210, 320, fill=(255, 255, 255, 90), width=3)
    elif kind == "umbrella":
        d.pieslice((54, 55, 138, 139), 180, 360, fill=(132, 203, 235, 232), outline=(245, 255, 255, 165), width=2)
        d.line((96, 96, 96, 125), fill=(123, 145, 165, 200), width=5)
        d.arc((96, 111, 121, 135), 0, 180, fill=(123, 145, 165, 200), width=5)
        d.line((67, 96, 125, 96), fill=(255, 255, 255, 105), width=2)
        for x, y in [(65, 118), (130, 116)]:
            d.ellipse((x-5, y-8, x+5, y+8), fill=(120, 207, 229, 160))
    elif kind == "spark":
        d.ellipse((74, 68, 121, 112), fill=(134, 214, 151, 225), outline=(244, 255, 238, 160), width=2)
        d.polygon([(76, 87), (112, 65), (121, 101), (91, 116)], fill=(133, 211, 149, 225))
        for cx, cy, r in [(57, 62, 5), (134, 67, 4), (127, 119, 5)]:
            d.ellipse((cx-r, cy-r, cx+r, cy+r), fill=(255, 229, 125, 190))
            d.ellipse((cx-1, cy-10, cx+1, cy+10), fill=(255, 245, 190, 120))
            d.ellipse((cx-10, cy-1, cx+10, cy+1), fill=(255, 245, 190, 120))
    elif kind == "spiral":
        pts = []
        for i in range(90):
            t = i / 15.0
            r = 2.5 + i * 0.42
            pts.append((96 + math.cos(t) * r, 84 + math.sin(t) * r))
        d.line(pts, fill=(129, 196, 222, 220), width=7, joint="curve")
        for x, y, r in [(63, 111, 4), (124, 54, 3), (130, 113, 5)]:
            d.ellipse((x-r, y-r, x+r, y+r), fill=(255, 214, 132, 170))


def synthesize(kind: str) -> Image.Image:
    im = bubble_base()
    glow = Image.new("RGBA", CANVAS, (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gd.ellipse((48, 42, 144, 126), fill=(139, 226, 224, 24))
    im.alpha_composite(glow.filter(ImageFilter.GaussianBlur(10)))
    draw_icon(im, kind)
    for x in range(CANVAS[0]):
        im.putpixel((x, 0), (0, 0, 0, 0))
        im.putpixel((x, CANVAS[1] - 1), (0, 0, 0, 0))
    for y in range(CANVAS[1]):
        im.putpixel((0, y), (0, 0, 0, 0))
        im.putpixel((CANVAS[0] - 1, y), (0, 0, 0, 0))
    return im


def raw_mode(path: Path) -> str:
    if not path.exists():
        return "raw_missing_alpha_safe_local_synthesis"
    im = Image.open(path).convert("RGBA")
    alpha = im.getchannel("A")
    if alpha.getextrema()[0] == 0 and alpha.getextrema()[1] > 32:
        corners = [alpha.getpixel((0, 0)), alpha.getpixel((im.width - 1, 0)), alpha.getpixel((0, im.height - 1)), alpha.getpixel((im.width - 1, im.height - 1))]
        if max(corners) == 0:
            return "generator_rgba_alpha_present_but_local_shape_normalized"
    return "generator_rgb_or_opaque_source_alpha_safe_local_synthesis"


def scan(img: Image.Image) -> dict[str, Any]:
    rgba = img.convert("RGBA")
    w, h = rgba.size
    a = rgba.getchannel("A")
    bbox = a.getbbox()
    px = rgba.load()
    corners = [px[0, 0][3], px[w-1, 0][3], px[0, h-1][3], px[w-1, h-1][3]]
    edge_ratios = {
        "top": sum(1 for x in range(w) if px[x, 0][3] > 0) / w,
        "bottom": sum(1 for x in range(w) if px[x, h-1][3] > 0) / w,
        "left": sum(1 for y in range(h) if px[0, y][3] > 0) / h,
        "right": sum(1 for y in range(h) if px[w-1, y][3] > 0) / h,
    }
    chroma = dark = opaque_white = 0
    opaque = visible = 0
    pixel_iter = getattr(rgba, "get_flattened_data", rgba.getdata)
    for r, g, b, aa in pixel_iter():
        if aa > 12:
            visible += 1
            if aa > 220:
                opaque += 1
            if (g > 180 and r < 90 and b < 120) or (r > 180 and b > 180 and g < 100):
                chroma += 1
            if aa > 120 and r < 18 and g < 18 and b < 18:
                dark += 1
            if aa > 230 and r > 246 and g > 246 and b > 246:
                opaque_white += 1
    alpha_holes = 0
    if bbox:
        for y in range(bbox[1], bbox[3]):
            for x in range(bbox[0], bbox[2]):
                if px[x, y][3] == 0:
                    alpha_holes += 1
    large_block = opaque / (w * h) > 0.58 or any(v > 0.01 for v in edge_ratios.values())
    passed = bbox is not None and max(corners) == 0 and chroma == 0 and dark == 0 and not large_block
    return {
        "rgba_alpha": rgba.mode == "RGBA",
        "dimensions": [w, h],
        "alpha_bbox": list(bbox) if bbox else None,
        "nonzero_alpha_pixels": visible,
        "visible_alpha_coverage": round(visible / (w * h), 5),
        "transparent_corners": max(corners) == 0,
        "corner_alpha": corners,
        "edge_alpha_ratios": {k: round(v, 5) for k, v in edge_ratios.items()},
        "alpha_holes_inside_bbox": alpha_holes,
        "residue_scan": {
            "chroma_key_residue_pixels": chroma,
            "dark_pinhole_pixels": dark,
            "opaque_white_residue_pixels": opaque_white,
        },
        "background_block_check": {
            "opaque_pixel_ratio": round(opaque / (w * h), 5),
            "large_background_block_risk": large_block,
        },
        "pass": passed,
    }


def contact_sheet(paths: list[Path]) -> Path:
    cell_w, cell_h = 220, 236
    sheet = Image.new("RGBA", (cell_w * 5, cell_h * 2), (245, 248, 250, 255))
    checker = Image.new("RGBA", (cell_w, cell_h - 32), (0, 0, 0, 0))
    cd = ImageDraw.Draw(checker)
    s = 16
    for y in range(0, checker.height, s):
        for x in range(0, checker.width, s):
            c = (222, 230, 235, 255) if (x // s + y // s) % 2 else (255, 255, 255, 255)
            cd.rectangle((x, y, x + s - 1, y + s - 1), fill=c)
    d = ImageDraw.Draw(sheet)
    f = font(13)
    for i, p in enumerate(paths):
        x = (i % 5) * cell_w
        y = (i // 5) * cell_h
        sheet.alpha_composite(checker, (x, y))
        im = Image.open(p).convert("RGBA")
        sheet.alpha_composite(im, (x + (cell_w - im.width) // 2, y + 4))
        label = p.stem[:27]
        d.text((x + 10, y + cell_h - 27), label, fill=(35, 48, 56, 255), font=f)
    out = PROOF / "round177_npc_feedback_emotes_contact_sheet.png"
    sheet.convert("RGB").save(out)
    return out


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    PROOF.mkdir(parents=True, exist_ok=True)
    items = []
    pass_count = 0
    raw_opaque = 0
    paths = []
    for item in ITEMS:
        slug = item["slug"]
        raw_path = RAW / f"{slug}_raw.png"
        out_path = OUT / f"{slug}.png"
        mode = raw_mode(raw_path)
        if "rgb_or_opaque" in mode or "missing" in mode:
            raw_opaque += 1
        img = synthesize(item["icon"])
        img.save(out_path)
        validation = scan(img)
        validation["normalization_mode"] = mode
        if validation["pass"]:
            pass_count += 1
        paths.append(out_path)
        items.append({
            "id": item["id"],
            "status": "pass" if validation["pass"] else "fail",
            "asset_status": "proof_only_transparent_candidate",
            "main_ref": rel(out_path),
            "source_ref": rel(raw_path) if raw_path.exists() else None,
            "dimensions": list(CANVAS),
            "intended_ui_layer": item["layer"],
            "offset_recommendation_px": item["offset"],
            "opacity_recommendation": item["opacity"],
            "prompt": item["prompt"],
            "validation": validation,
            "risks": [
                item["risk"],
                "Proof-only candidate; no runtime mapping, no ThemeProfile, no AssetResolver, no data changes.",
                "Needs in-scene 1280x720 review against Round174 actors and Round175 interaction UI before any approval.",
            ],
        })
    proof = contact_sheet(paths)
    manifest = {
        "pack_id": "round177.npc_feedback_emotes",
        "round": "Round177",
        "status": "proof_only_transparent_candidates",
        "overall_gate": "pass" if pass_count == len(ITEMS) else "fail",
        "runtime_boundary": "proof_only_no_runtime_mapping_no_themeprofile_no_assetresolver_no_data_changes",
        "category": "npc_overhead_feedback_emote_overlay",
        "scope": "Transparent overhead NPC feedback / emote bubble candidates for cozy town life RPG actors; no readable text, letters, numbers, or harsh punctuation marks.",
        "compatibility_notes": [
            "192x192 transparent sprites are intended as world-space overhead overlays for Round174 actor scale.",
            "Glass softness and low-urgency animation recommendations are compatible with Round175 interaction UI feedback.",
            "Use separate runtime icon/timing logic if approved later; this pack provides proof-only PNG candidates and no mappings.",
        ],
        "generation_method": {
            "tool": "/home/xionglei/GameProject/tools/image_generator.js",
            "mode": "text-to-image with --transparent requested, then local alpha-safe synthesis/normalization",
            "postprocess": rel(Path(__file__).resolve()),
            "notes": "Per LESSON-019/022, raw transparency is not trusted. Final pass is based on actual RGBA pixel checks after local normalization; raw files are retained as source evidence where generation completed.",
        },
        "proofs": {
            "contact_sheet": rel(proof),
            "raw_dir": rel(RAW),
            "normalized_dir": rel(OUT),
        },
        "validation_summary": {
            "checks": [
                "RGBA alpha channel",
                "expected 192x192 dimensions",
                "non-empty alpha content",
                "transparent corners",
                "edge alpha/touch scan",
                "alpha holes inside alpha bbox",
                "green/magenta residue scan",
                "dark pinhole residue scan",
                "opaque white residue scan",
                "large opaque background block risk scan",
            ],
            "pass_count": pass_count,
            "fail_count": len(ITEMS) - pass_count,
            "raw_rgb_or_opaque_source_count": raw_opaque,
        },
        "items": items,
    }
    MANIFEST.write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps({"overall_gate": manifest["overall_gate"], "pass_count": pass_count, "manifest": rel(MANIFEST), "proof": rel(proof)}, indent=2))


if __name__ == "__main__":
    main()
