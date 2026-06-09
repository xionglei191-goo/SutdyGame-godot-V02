#!/usr/bin/env python3
from __future__ import annotations

import json
from collections import deque
from pathlib import Path

from PIL import Image, ImageDraw


ROOT = Path(__file__).resolve().parent
OUT = ROOT / "normalized_192x192"
PROOF = ROOT / "proof"
CANVAS = (192, 192)
RUNTIME_BOUNDARY = "proof_only_no_runtime_mapping_no_themeprofile_no_assetresolver_no_data_changes"
ASSET_ROOT = Path("assets/art/visual_rebuild/round179/school_shop_daily_props")


ITEMS = [
    {
        "slug": "school_gate_flower_pot",
        "place": "School Gate",
        "pivot": [96, 160],
        "footprint": "1x1 low welcoming gate-side planter prop",
        "layer": "above path/plaza ground, below actors",
        "risk": "Gate association must stay welcoming and decorative, not institutional or test-like.",
    },
    {
        "slug": "shoe_cubby_soft",
        "place": "School Gate",
        "pivot": [96, 160],
        "footprint": "2x1 low entry cubby prop; soft blocking edge",
        "layer": "above entry floor or path edge, below tall signs",
        "risk": "Cubby should read as daily routine storage, not classroom pressure.",
    },
    {
        "slug": "yard_jump_rope_coil",
        "place": "School Yard",
        "pivot": [96, 156],
        "footprint": "1x1 very low play prop; non-blocking",
        "layer": "above yard ground, below actors",
        "risk": "Thin rope needs mobile readability against grass and plaza floors.",
    },
    {
        "slug": "yard_ball_basket",
        "place": "School Yard",
        "pivot": [96, 160],
        "footprint": "1x1 low play basket; soft blocking boundary",
        "layer": "above yard ground, below actors",
        "risk": "Ball patches must not look like logos, score marks, or sports-team labels.",
    },
    {
        "slug": "bookshop_window_stack",
        "place": "Bookshop",
        "pivot": [96, 162],
        "footprint": "1x1 window display stack; low-front decorative prop",
        "layer": "above shop front floor/window ledge, below characters",
        "risk": "Book covers must remain blank, with no visible text labels or schoolwork cue.",
    },
    {
        "slug": "bookshop_reading_cushion",
        "place": "Bookshop",
        "pivot": [96, 160],
        "footprint": "1x1 low soft seating prop",
        "layer": "above bookshop floor or outdoor reading nook, below actors",
        "risk": "Needs future scale review beside sitting animation before runtime use.",
    },
    {
        "slug": "shop_fruit_crate",
        "place": "Shop Front",
        "pivot": [96, 162],
        "footprint": "1x1 produce display crate; soft blocking boundary",
        "layer": "above shop front ground, below canopy/tall props",
        "risk": "Fruit shapes should stay chunky and safe, not tiny choking-size realism.",
    },
    {
        "slug": "shop_bread_tray",
        "place": "Shop Front",
        "pivot": [96, 160],
        "footprint": "1x1 bakery display tray; low prop",
        "layer": "above counter/shop ground, below actors",
        "risk": "Bread details should remain abstract and cozy rather than realistic food sales UI.",
    },
    {
        "slug": "shop_small_price_leaf_blank",
        "place": "Shop Front",
        "pivot": [96, 158],
        "footprint": "1x1 tiny blank leaf tag; decorative marker only",
        "layer": "above crate/counter or shop front ground",
        "risk": "Must remain blank; no numbers, currency, sale symbols, or exclamation cue.",
    },
    {
        "slug": "bus_stop_bench_cushion",
        "place": "Bus Stop",
        "pivot": [96, 162],
        "footprint": "2x1 low bench cushion prop; soft blocking boundary",
        "layer": "above bus stop paving, below waiting actors",
        "risk": "Bench should feel like a waiting/rest prop, not a UI button or route marker.",
    },
    {
        "slug": "bus_stop_timetable_blank_board",
        "place": "Bus Stop",
        "pivot": [96, 164],
        "footprint": "1x1 upright blank board; blocking decorative prop",
        "layer": "above bus stop paving, below canopy/tall tree layers",
        "risk": "Board must stay blank: no route text, numbers, arrows, school schedules, or marks.",
    },
    {
        "slug": "plaza_notice_leaf_blank",
        "place": "Shop Front / Plaza",
        "pivot": [96, 164],
        "footprint": "1x1 blank leaf notice prop; decorative community board",
        "layer": "above plaza ground, below tall props",
        "risk": "Blank notice board cannot carry quests, exclamation marks, or readable text yet.",
    },
]


def sc(value, scale: int):
    if isinstance(value, tuple):
        return tuple(int(round(v * scale)) for v in value)
    return int(round(value * scale))


def draw_item(slug: str) -> Image.Image:
    scale = 4
    img = Image.new("RGBA", (CANVAS[0] * scale, CANVAS[1] * scale), (0, 0, 0, 0))
    d = ImageDraw.Draw(img, "RGBA")

    def ellipse(box, fill, outline=None, width=1):
        d.ellipse(sc(box, scale), fill=fill, outline=outline, width=sc(width, scale))

    def rr(box, radius, fill, outline=None, width=1):
        d.rounded_rectangle(sc(box, scale), radius=sc(radius, scale), fill=fill, outline=outline, width=sc(width, scale))

    def line(points, fill, width=1):
        d.line([sc(p, scale) for p in points], fill=fill, width=sc(width, scale), joint="curve")

    def poly(points, fill, outline=None):
        d.polygon([sc(p, scale) for p in points], fill=fill, outline=outline)

    shadow = (82, 66, 48, 38)
    outline = (116, 82, 55, 255)
    cocoa = (126, 84, 55, 255)
    wood = (195, 132, 75, 255)
    wood_light = (229, 171, 99, 255)
    cream = (255, 238, 203, 255)
    honey = (247, 194, 91, 255)
    peach = (250, 171, 128, 255)
    rose = (230, 127, 136, 255)
    mint = (113, 193, 160, 255)
    leaf = (106, 171, 102, 255)
    leaf_dark = (70, 128, 84, 255)
    teal = (83, 163, 169, 255)
    blue = (110, 174, 219, 255)
    lavender = (168, 149, 218, 255)

    if slug == "school_gate_flower_pot":
        ellipse((44, 134, 148, 166), shadow)
        rr((60, 92, 132, 153), 14, (212, 119, 88, 255), (133, 77, 57, 255), 3)
        rr((52, 82, 140, 105), 12, peach, outline, 3)
        ellipse((62, 75, 130, 96), (98, 62, 44, 255))
        for cx, cy, c in [(69, 67, rose), (88, 54, honey), (107, 66, lavender), (122, 55, cream)]:
            line([(96, 85), (cx, cy + 8)], leaf_dark, 3)
            for dx, dy in [(-7, 0), (0, -7), (7, 0), (0, 7)]:
                ellipse((cx + dx - 5, cy + dy - 5, cx + dx + 5, cy + dy + 5), c)
            ellipse((cx - 4, cy - 4, cx + 4, cy + 4), (255, 221, 118, 255))
        ellipse((80, 80, 97, 94), leaf)
        ellipse((99, 78, 118, 92), leaf)
    elif slug == "shoe_cubby_soft":
        ellipse((26, 136, 166, 166), shadow)
        rr((33, 66, 159, 145), 13, wood_light, outline, 3)
        line([(35, 102), (157, 102)], (157, 99, 60, 255), 3)
        line([(75, 68), (75, 144)], (157, 99, 60, 255), 3)
        line([(117, 68), (117, 144)], (157, 99, 60, 255), 3)
        for box, c in [((47, 118, 69, 134), teal), ((87, 118, 110, 134), rose), ((126, 117, 149, 134), mint)]:
            ellipse(box, c, (67, 83, 84, 180), 1)
        rr((45, 76, 64, 91), 6, cream, (153, 116, 69, 200), 1)
        rr((88, 78, 106, 91), 6, (245, 215, 143, 255), (153, 116, 69, 200), 1)
        rr((129, 77, 146, 91), 6, (199, 224, 206, 255), (92, 128, 93, 200), 1)
    elif slug == "yard_jump_rope_coil":
        ellipse((49, 132, 143, 158), shadow)
        for offset, color in [(0, teal), (7, (98, 188, 184, 255)), (14, (139, 211, 199, 255))]:
            ellipse((54 + offset, 74 + offset, 139 - offset, 141 - offset), (0, 0, 0, 0), color, 6)
        line([(55, 112), (34, 100), (29, 86)], teal, 5)
        line([(137, 113), (160, 101), (166, 87)], teal, 5)
        rr((22, 76, 37, 93), 5, honey, outline, 2)
        rr((156, 76, 171, 93), 5, rose, outline, 2)
    elif slug == "yard_ball_basket":
        ellipse((42, 131, 151, 164), shadow)
        rr((47, 83, 146, 151), 16, wood_light, outline, 3)
        for x in [64, 82, 100, 118, 136]:
            line([(x, 88), (x - 10, 148)], (151, 97, 57, 180), 2)
        for y in [102, 120, 138]:
            line([(51, y), (143, y)], (151, 97, 57, 180), 2)
        ellipse((58, 57, 101, 101), honey, outline, 2)
        ellipse((89, 54, 134, 101), blue, (55, 105, 145, 255), 2)
        ellipse((78, 74, 119, 116), rose, (142, 70, 78, 255), 2)
        line([(91, 55), (111, 99)], (255, 255, 255, 105), 2)
    elif slug == "bookshop_window_stack":
        ellipse((42, 135, 151, 166), shadow)
        rr((45, 124, 148, 151), 9, wood, outline, 2)
        for box, c in [
            ((59, 102, 134, 124), mint),
            ((52, 82, 127, 103), honey),
            ((66, 61, 139, 83), lavender),
            ((74, 42, 131, 62), peach),
        ]:
            rr(box, 5, c, outline, 2)
            line([(box[0] + 9, box[1] + 4), (box[0] + 9, box[3] - 4)], (255, 255, 255, 100), 2)
        ellipse((124, 104, 148, 129), leaf, leaf_dark, 2)
    elif slug == "bookshop_reading_cushion":
        ellipse((34, 127, 159, 164), shadow)
        rr((39, 71, 153, 149), 28, (235, 143, 132, 255), (140, 82, 75, 255), 3)
        rr((55, 84, 137, 137), 22, (255, 209, 153, 255), (168, 107, 72, 255), 2)
        for p in [(61, 96), (131, 96), (62, 126), (130, 126)]:
            ellipse((p[0] - 4, p[1] - 4, p[0] + 4, p[1] + 4), cream)
        line([(61, 112), (131, 112)], (218, 142, 111, 150), 2)
    elif slug == "shop_fruit_crate":
        ellipse((34, 132, 158, 166), shadow)
        rr((42, 91, 151, 151), 12, wood_light, outline, 3)
        line([(48, 111), (146, 111)], (153, 96, 58, 210), 3)
        line([(61, 93), (56, 149)], (153, 96, 58, 180), 2)
        line([(130, 93), (135, 149)], (153, 96, 58, 180), 2)
        for cx, cy, c in [(68, 76, rose), (88, 69, honey), (109, 75, peach), (125, 66, mint), (98, 90, rose)]:
            ellipse((cx - 15, cy - 13, cx + 15, cy + 15), c, outline, 2)
            ellipse((cx - 2, cy - 19, cx + 10, cy - 9), leaf, leaf_dark, 1)
    elif slug == "shop_bread_tray":
        ellipse((35, 130, 158, 162), shadow)
        rr((39, 103, 154, 145), 13, wood, outline, 3)
        rr((50, 90, 145, 123), 13, (237, 174, 90, 255), (142, 91, 50, 255), 2)
        for box in [(53, 67, 83, 104), (78, 61, 112, 104), (108, 67, 140, 104)]:
            ellipse(box, (248, 203, 121, 255), (144, 93, 50, 255), 2)
            line([(box[0] + 11, box[1] + 10), (box[0] + 21, box[1] + 26)], (255, 239, 171, 160), 2)
    elif slug == "shop_small_price_leaf_blank":
        ellipse((56, 131, 137, 158), shadow)
        line([(75, 126), (60, 145)], cocoa, 5)
        ellipse((55, 68, 137, 134), leaf, leaf_dark, 3)
        poly([(96, 64), (131, 83), (118, 126), (83, 135), (55, 103)], leaf, leaf_dark)
        line([(67, 106), (126, 87)], (218, 239, 174, 150), 2)
        rr((75, 91, 116, 112), 8, (233, 247, 194, 150), None, 1)
    elif slug == "bus_stop_bench_cushion":
        ellipse((20, 136, 173, 166), shadow)
        rr((31, 71, 161, 101), 12, wood_light, outline, 3)
        rr((27, 101, 165, 132), 13, teal, (54, 109, 117, 255), 3)
        rr((39, 86, 153, 119), 11, (115, 194, 190, 255), None, 1)
        line([(50, 132), (43, 156)], cocoa, 5)
        line([(142, 132), (149, 156)], cocoa, 5)
        line([(37, 78), (155, 78)], (255, 226, 149, 120), 2)
    elif slug == "bus_stop_timetable_blank_board":
        ellipse((50, 139, 145, 169), shadow)
        line([(70, 80), (70, 157)], cocoa, 7)
        line([(122, 80), (122, 157)], cocoa, 7)
        rr((48, 45, 144, 113), 12, (129, 189, 183, 255), (58, 111, 112, 255), 3)
        rr((61, 58, 131, 100), 8, (245, 236, 202, 255), (137, 118, 86, 255), 2)
        rr((43, 34, 149, 54), 10, honey, outline, 2)
        ellipse((128, 100, 144, 116), leaf, leaf_dark, 1)
    elif slug == "plaza_notice_leaf_blank":
        ellipse((48, 139, 146, 170), shadow)
        line([(95, 107), (95, 159)], cocoa, 8)
        ellipse((47, 45, 145, 122), leaf, leaf_dark, 3)
        poly([(95, 38), (137, 57), (142, 94), (111, 124), (68, 120), (49, 86), (61, 57)], leaf, leaf_dark)
        rr((68, 68, 123, 97), 10, (230, 245, 190, 150), None, 1)
        line([(71, 102), (119, 64)], (222, 239, 173, 130), 2)
        rr((70, 122, 121, 137), 6, wood_light, outline, 2)

    img = img.resize(CANVAS, Image.Resampling.LANCZOS)
    alpha = img.getchannel("A").point(lambda a: 0 if a < 32 else a)
    img.putalpha(alpha)
    return img


def alpha_bbox(img: Image.Image) -> list[int] | None:
    bbox = img.getchannel("A").getbbox()
    if bbox is None:
        return None
    return [int(v) for v in bbox]


def largest_opaque_component_ratio(img: Image.Image) -> float:
    alpha = img.getchannel("A")
    w, h = img.size
    visited = set()
    opaque = set()
    for y in range(h):
        for x in range(w):
            if alpha.getpixel((x, y)) >= 248:
                opaque.add((x, y))
    largest = 0
    for point in opaque:
        if point in visited:
            continue
        count = 0
        queue = deque([point])
        visited.add(point)
        while queue:
            x, y = queue.popleft()
            count += 1
            for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                n = (nx, ny)
                if n in opaque and n not in visited:
                    visited.add(n)
                    queue.append(n)
        largest = max(largest, count)
    return round(largest / float(w * h), 5)


def validate_image(path: Path) -> dict:
    img = Image.open(path).convert("RGBA")
    alpha = img.getchannel("A")
    w, h = img.size
    histogram = alpha.histogram()
    nonzero = sum(histogram[1:])
    corners = [
        alpha.getpixel((0, 0)),
        alpha.getpixel((w - 1, 0)),
        alpha.getpixel((0, h - 1)),
        alpha.getpixel((w - 1, h - 1)),
    ]
    edge_ratios = {
        "top": round(sum(1 for x in range(w) if alpha.getpixel((x, 0)) > 0) / w, 4),
        "bottom": round(sum(1 for x in range(w) if alpha.getpixel((x, h - 1)) > 0) / w, 4),
        "left": round(sum(1 for y in range(h) if alpha.getpixel((0, y)) > 0) / h, 4),
        "right": round(sum(1 for y in range(h) if alpha.getpixel((w - 1, y)) > 0) / h, 4),
    }
    rgba = img.mode == "RGBA"
    chroma = 0
    dark = 0
    opaque = 0
    pix = img.load()
    for y in range(h):
        for x in range(w):
            r, g, b, a = pix[x, y]
            if a > 0:
                if g > 210 and r < 80 and b < 120:
                    chroma += 1
                if b > 210 and r > 180 and g < 80:
                    chroma += 1
                if a < 60 and r < 12 and g < 12 and b < 12:
                    dark += 1
                if a >= 248:
                    opaque += 1
    largest_component = largest_opaque_component_ratio(img)
    block_risk = largest_component > 0.35 and all(v == 0 for v in corners)
    return {
        "normalization_mode": "local_vector_rgba_synthesis_real_alpha",
        "rgba_alpha": rgba,
        "dimensions": [w, h],
        "alpha_bbox": alpha_bbox(img),
        "nonzero_alpha_pixels": nonzero,
        "visible_alpha_coverage": round(nonzero / float(w * h), 5),
        "transparent_corners": all(v == 0 for v in corners),
        "corner_alpha": corners,
        "edge_alpha_ratios": edge_ratios,
        "residue_scan": {
            "chroma_key_residue_pixels": chroma,
            "dark_pinhole_pixels": dark,
            "edge_touch_sides_over_1pct": sum(1 for v in edge_ratios.values() if v > 0.01),
        },
        "background_block_check": {
            "opaque_pixel_ratio": round(opaque / float(w * h), 5),
            "largest_opaque_component_ratio": largest_component,
            "large_background_block_risk": block_risk,
        },
        "content_safety_check": {
            "visible_text_labels": False,
            "letters_numbers_currency_or_scores": False,
            "exclamation_heavy_cue": False,
            "class_test_homework_pressure": False,
        },
        "pass": (
            rgba
            and [w, h] == list(CANVAS)
            and nonzero > 500
            and all(v == 0 for v in corners)
            and chroma == 0
            and dark == 0
            and sum(1 for v in edge_ratios.values() if v > 0.01) == 0
            and not block_risk
        ),
    }


def make_contact_sheet(item_records: list[dict]) -> None:
    cell_w, cell_h = 220, 220
    cols = 4
    rows = 3
    sheet = Image.new("RGBA", (cols * cell_w, rows * cell_h), (244, 238, 224, 255))
    d = ImageDraw.Draw(sheet, "RGBA")
    for i, record in enumerate(item_records):
        x = (i % cols) * cell_w
        y = (i // cols) * cell_h
        d.rounded_rectangle((x + 10, y + 10, x + cell_w - 10, y + cell_h - 10), radius=8, fill=(255, 250, 238, 255), outline=(196, 173, 131, 255), width=2)
        bg = Image.new("RGBA", CANVAS, (224, 238, 218, 255))
        bg_d = ImageDraw.Draw(bg, "RGBA")
        for yy in range(0, CANVAS[1], 24):
            bg_d.line([(0, yy), (CANVAS[0], yy)], fill=(207, 224, 202, 255), width=1)
        prop = Image.open(record["normalized_png"]).convert("RGBA")
        bg.alpha_composite(prop)
        sheet.alpha_composite(bg, (x + 14, y + 16))
    PROOF.mkdir(parents=True, exist_ok=True)
    sheet.convert("RGB").save(PROOF / "round179_school_shop_daily_props_contact_sheet.png")


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    PROOF.mkdir(parents=True, exist_ok=True)
    item_records = []
    for item in ITEMS:
        slug = item["slug"]
        path = OUT / f"{slug}.png"
        manifest_path = ASSET_ROOT / "normalized_192x192" / f"{slug}.png"
        draw_item(slug).save(path)
        validation = validate_image(path)
        status = "pass" if validation["pass"] else "fail"
        item_records.append({
            "id": f"school_shop_daily_props.{slug}",
            "logical_asset_id": f"school_shop_daily_props.{slug}",
            "slug": slug,
            "place": item["place"],
            "status": status,
            "asset_status": "proof_only_transparent_candidate",
            "main_ref": str(manifest_path),
            "normalized_png": str(manifest_path),
            "dimensions": list(CANVAS),
            "pivot_recommendation_px": item["pivot"],
            "footprint_recommendation": item["footprint"],
            "layer_recommendation": item["layer"],
            "visual_style_notes": "child-safe cozy town daily-life prop, rounded warm Animal Crossing-like proportions, no visible text labels, no test/score/homework pressure",
            "generation_provenance": {
                "method": "local transparent RGBA vector/raster synthesis using Pillow",
                "raw_alpha_note": "No external RGB/opaque raw was used; real alpha is verified directly on each emitted PNG per LESSON-022.",
            },
            "validation": validation,
            "risks": [
                item["risk"],
                "Proof-only candidate; no runtime, ThemeProfile, AssetResolver, data, shared-test, art_target_locked, or runtime_visual_match mapping.",
                "Final art direction and in-scene scale review are required before any production/runtime use.",
            ],
        })
    make_contact_sheet(item_records)
    failed = [record for record in item_records if record["status"] != "pass"]
    manifest = {
        "pack_id": "round179.school_shop_daily_props",
        "round": "Round179",
        "worker": "Worker B",
        "status": "proof_only_transparent_candidates",
        "overall_gate": "pass" if not failed else "fail",
        "runtime_boundary": RUNTIME_BOUNDARY,
        "category": "school_shop_daily_props",
        "scope": "Twelve child-safe cozy daily-life prop candidates for school gate, school yard, shop front, bookshop, and bus stop; no runtime mapping or production approval.",
        "negative_constraints": [
            "no visible text labels on prop art",
            "no letters, numbers, currency, scores, route text, or sale labels",
            "no exclamation-heavy cue",
            "no class/test/homework pressure",
            "no ThemeProfile, AssetResolver, data, runtime, shared-test, art_target_locked, or runtime_visual_match changes",
        ],
        "generation_method": {
            "tool": "assets/art/visual_rebuild/round179/school_shop_daily_props/generate_validate_manifest.py",
            "mode": "local transparent RGBA synthesis",
            "postprocess": "same script validates alpha/residue/background-block gates and writes manifest/contact sheet",
            "notes": "Per LESSON-022, final gate is based on actual RGBA alpha audit, not generator flags. Per LESSON-021, a large opaque component background-block risk scan is included.",
        },
        "proof": "assets/art/visual_rebuild/round179/school_shop_daily_props/proof/round179_school_shop_daily_props_contact_sheet.png",
        "proofs": {
            "contact_sheet": "assets/art/visual_rebuild/round179/school_shop_daily_props/proof/round179_school_shop_daily_props_contact_sheet.png",
            "normalized_dir": "assets/art/visual_rebuild/round179/school_shop_daily_props/normalized_192x192",
        },
        "validation_summary": {
            "checks": [
                "RGBA alpha channel",
                "expected normalized 192x192 dimensions",
                "non-empty alpha content",
                "transparent corner alpha",
                "edge residue / edge-touch scan",
                "green/magenta chroma-key residue scan",
                "dark pinhole residue scan",
                "large opaque background block risk scan",
                "manual content-safety declaration: blank/no text/no school pressure",
            ],
            "pass_count": len(item_records) - len(failed),
            "fail_count": len(failed),
            "raw_rgb_or_opaque_source_count": 0,
            "visual_background_block_count": sum(1 for record in item_records if record["validation"]["background_block_check"]["large_background_block_risk"]),
            "visible_text_label_count": 0,
            "class_test_homework_pressure_count": 0,
        },
        "items": item_records,
    }
    (ROOT / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({
        "manifest": str(ROOT / "manifest.json"),
        "overall_gate": manifest["overall_gate"],
        "item_count": len(item_records),
        "failed": [record["slug"] for record in failed],
        "proof": manifest["proof"],
    }, ensure_ascii=False, indent=2))
    raise SystemExit(1 if failed else 0)


if __name__ == "__main__":
    main()
