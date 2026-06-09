#!/usr/bin/env python3
from __future__ import annotations

import json
from collections import deque
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parent
OUT = ROOT / "normalized_192x192"
PROOF = ROOT / "proof"
CANVAS = (192, 192)
RUNTIME_BOUNDARY = "proof_only_no_runtime_mapping_no_themeprofile_no_assetresolver_no_data_changes"


ITEMS = [
    {
        "slug": "sunny_cushion_round",
        "id": "companion_care_props.sunny_cushion_round",
        "pivot": [96, 158],
        "footprint": "1x1 low soft furniture prop; non-blocking or low pet-only rest marker",
        "layer": "above home floor / yard mat, below companion and actor feet",
        "risk": "Round cushion could read as generic home furniture unless reviewed beside companion-care UI.",
    },
    {
        "slug": "tiny_food_bowl",
        "id": "companion_care_props.tiny_food_bowl",
        "pivot": [96, 154],
        "footprint": "1x1 low bowl prop; tiny interaction hotspot only",
        "layer": "above floor/path, below actors",
        "risk": "Food pieces must stay abstract and child-safe, not realistic choking-size detail.",
    },
    {
        "slug": "water_bowl_flower",
        "id": "companion_care_props.water_bowl_flower",
        "pivot": [96, 154],
        "footprint": "1x1 low bowl prop; tiny interaction hotspot only",
        "layer": "above floor/path, below actors",
        "risk": "Flower motif should remain decorative and not read as readable iconography.",
    },
    {
        "slug": "grooming_brush_soft",
        "id": "companion_care_props.grooming_brush_soft",
        "pivot": [96, 154],
        "footprint": "1x1 handheld care prop; inventory or placed-table scale",
        "layer": "above surface/floor, below tall props",
        "risk": "Bristles are small; needs mobile-scale readability before runtime use.",
    },
    {
        "slug": "ribbon_collar_charm",
        "id": "companion_care_props.ribbon_collar_charm",
        "pivot": [96, 150],
        "footprint": "1x1 small accessory prop; inventory scale",
        "layer": "UI/inventory candidate or above floor as small prop",
        "risk": "Charm must stay abstract; no letters, numbers, symbols, or logo shapes.",
    },
    {
        "slug": "plush_ball_toy",
        "id": "companion_care_props.plush_ball_toy",
        "pivot": [96, 154],
        "footprint": "1x1 low toy prop; non-blocking companion play marker",
        "layer": "above floor/path, below actors",
        "risk": "Patch marks should not be mistaken for text or sports branding.",
    },
    {
        "slug": "folded_pet_blanket",
        "id": "companion_care_props.folded_pet_blanket",
        "pivot": [96, 154],
        "footprint": "1x1 low textile stack; non-blocking or low decor",
        "layer": "above home floor / companion corner floor, below actors",
        "risk": "Low textile silhouette needs check against home floor colors.",
    },
    {
        "slug": "bath_towel_stack",
        "id": "companion_care_props.bath_towel_stack",
        "pivot": [96, 154],
        "footprint": "1x1 low textile stack; bath/care corner prop",
        "layer": "above surface/floor, below actors",
        "risk": "Stack height and highlights need scale check beside companion bed.",
    },
    {
        "slug": "paw_print_moment_marker",
        "id": "companion_care_props.paw_print_moment_marker",
        "pivot": [96, 154],
        "footprint": "1x1 tiny moment marker; optional non-blocking feedback prop",
        "layer": "above floor/path as temporary care feedback marker",
        "risk": "Paw motif is symbolic; keep proof-only until UI/feedback semantics are reviewed.",
    },
    {
        "slug": "small_companion_bed",
        "id": "companion_care_props.small_companion_bed",
        "pivot": [96, 162],
        "footprint": "2x1 low companion rest furniture; soft blocking boundary around cushion",
        "layer": "above home floor / yard floor, below companion when sleeping inside",
        "risk": "Needs composition proof with Round174 Sunny companion scale before runtime mapping.",
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

    shadow = (93, 72, 54, 34)
    cocoa = (122, 82, 55, 255)
    wood = (196, 137, 79, 255)
    honey = (244, 188, 83, 255)
    cream = (255, 238, 196, 255)
    mint = (112, 191, 162, 255)
    teal = (66, 151, 159, 255)
    rose = (235, 132, 137, 255)
    peach = (255, 179, 130, 255)
    lavender = (164, 145, 219, 255)
    blue = (103, 176, 218, 255)
    leaf = (109, 174, 105, 255)

    if slug == "sunny_cushion_round":
        ellipse((35, 124, 157, 166), shadow)
        ellipse((36, 62, 156, 154), (247, 195, 83, 255), (171, 117, 61, 255), 3)
        ellipse((50, 74, 142, 143), (255, 219, 115, 255))
        for p in [(96, 67), (130, 87), (130, 122), (96, 145), (62, 122), (62, 87)]:
            line([(96, 108), p], (230, 166, 75, 128), 2)
        ellipse((81, 94, 111, 122), (255, 236, 159, 210))
    elif slug == "tiny_food_bowl":
        ellipse((44, 122, 148, 158), shadow)
        ellipse((42, 82, 150, 150), peach, (144, 86, 70, 255), 3)
        ellipse((55, 88, 137, 124), (255, 219, 181, 255), (167, 104, 78, 255), 2)
        for x, y, c in [(78, 101, honey), (96, 106, wood), (113, 99, honey), (90, 93, (216, 132, 73, 255))]:
            ellipse((x - 8, y - 6, x + 8, y + 7), c, (139, 91, 57, 170), 1)
        rr((60, 124, 132, 145), 13, (218, 112, 102, 255))
    elif slug == "water_bowl_flower":
        ellipse((44, 122, 148, 158), shadow)
        ellipse((42, 82, 150, 150), blue, (55, 116, 146, 255), 3)
        ellipse((55, 89, 137, 124), (178, 229, 245, 245), (75, 151, 183, 255), 2)
        ellipse((80, 95, 112, 112), (219, 249, 255, 165))
        for cx, cy in [(65, 78), (72, 71), (79, 78), (72, 85)]:
            ellipse((cx - 5, cy - 4, cx + 5, cy + 5), (255, 222, 126, 255))
        ellipse((68, 76, 76, 84), rose)
    elif slug == "grooming_brush_soft":
        ellipse((48, 132, 151, 157), shadow)
        rr((53, 82, 127, 126), 16, (253, 202, 127, 255), (134, 88, 55, 255), 3)
        rr((117, 109, 153, 128), 9, wood, cocoa, 2)
        for x in range(63, 119, 9):
            line([(x, 124), (x + 3, 142)], (108, 92, 80, 210), 2)
        rr((63, 72, 116, 91), 9, cream, (178, 126, 70, 255), 2)
    elif slug == "ribbon_collar_charm":
        ellipse((42, 124, 150, 151), shadow)
        line([(45, 100), (69, 81), (105, 78), (140, 97)], teal, 10)
        line([(45, 100), (69, 81), (105, 78), (140, 97)], (42, 113, 121, 255), 3)
        poly([(88, 92), (59, 77), (62, 116)], rose, (144, 71, 88, 255))
        poly([(102, 92), (132, 77), (129, 116)], rose, (144, 71, 88, 255))
        ellipse((86, 82, 106, 103), (252, 172, 177, 255), (144, 71, 88, 255), 2)
        ellipse((88, 111, 106, 130), honey, (132, 97, 48, 255), 2)
    elif slug == "plush_ball_toy":
        ellipse((43, 123, 149, 158), shadow)
        ellipse((50, 58, 142, 147), lavender, (95, 83, 145, 255), 3)
        ellipse((68, 75, 115, 127), (193, 179, 239, 255))
        poly([(102, 63), (129, 80), (123, 112), (92, 99)], mint, (61, 128, 112, 255))
        line([(57, 104), (79, 126), (113, 134), (139, 112)], (112, 94, 160, 150), 2)
        ellipse((119, 70, 132, 83), cream, (112, 94, 160, 160), 1)
    elif slug == "folded_pet_blanket":
        ellipse((37, 127, 157, 158), shadow)
        rr((42, 88, 151, 139), 16, (143, 205, 185, 255), (67, 128, 118, 255), 3)
        rr((53, 77, 141, 119), 15, (174, 225, 207, 255), (67, 128, 118, 255), 2)
        line([(58, 101), (135, 101)], (101, 162, 148, 190), 2)
        rr((56, 117, 135, 140), 11, (106, 176, 163, 255))
        for x in [70, 93, 116]:
            line([(x, 81), (x + 10, 114)], (235, 250, 230, 180), 2)
    elif slug == "bath_towel_stack":
        ellipse((46, 130, 148, 158), shadow)
        rr((51, 107, 143, 137), 12, (126, 198, 224, 255), (58, 118, 147, 255), 2)
        rr((58, 86, 136, 115), 12, (251, 215, 135, 255), (157, 112, 57, 255), 2)
        rr((66, 67, 128, 96), 12, (255, 242, 210, 255), (166, 134, 88, 255), 2)
        line([(63, 122), (132, 122)], (215, 244, 252, 180), 2)
        line([(72, 81), (121, 81)], (255, 250, 229, 210), 2)
    elif slug == "paw_print_moment_marker":
        ellipse((55, 125, 138, 154), shadow)
        ellipse((72, 95, 121, 135), (255, 199, 105, 255), (141, 101, 58, 255), 2)
        for cx, cy in [(69, 83), (87, 73), (107, 76), (122, 91)]:
            ellipse((cx - 9, cy - 8, cx + 9, cy + 9), (255, 210, 125, 255), (141, 101, 58, 255), 2)
    elif slug == "small_companion_bed":
        ellipse((23, 128, 169, 166), shadow)
        rr((30, 78, 162, 153), 30, (229, 139, 126, 255), (137, 82, 77, 255), 3)
        rr((48, 92, 144, 139), 23, (255, 211, 151, 255), (171, 112, 73, 255), 2)
        rr((37, 115, 155, 153), 20, (219, 120, 114, 255), (137, 82, 77, 255), 2)
        ellipse((62, 98, 130, 132), (255, 226, 173, 230))
        line([(55, 142), (137, 142)], (247, 171, 158, 170), 2)

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
    largest = 0
    opaque = set()
    for y in range(h):
        for x in range(w):
            if alpha.getpixel((x, y)) >= 248:
                opaque.add((x, y))
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
    bbox = alpha_bbox(img)
    histogram = alpha.histogram()
    nonzero = sum(histogram[1:])
    corners = [
        alpha.getpixel((0, 0)),
        alpha.getpixel((w - 1, 0)),
        alpha.getpixel((0, h - 1)),
        alpha.getpixel((w - 1, h - 1)),
    ]
    edge_ratios = {
        "top": round(sum(1 for x in range(w) if alpha.getpixel((x, 0)) > 0) / w, 5),
        "bottom": round(sum(1 for x in range(w) if alpha.getpixel((x, h - 1)) > 0) / w, 5),
        "left": round(sum(1 for y in range(h) if alpha.getpixel((0, y)) > 0) / h, 5),
        "right": round(sum(1 for y in range(h) if alpha.getpixel((w - 1, y)) > 0) / h, 5),
    }
    chroma = 0
    dark_pinhole = 0
    rgba = img.load()
    for y in range(h):
        for x in range(w):
            r, g, b, a = rgba[x, y]
            if a > 0 and ((g > 235 and r < 30 and b < 30) or (r > 235 and b > 235 and g < 30)):
                chroma += 1
            if 0 < a <= 32 and r < 8 and g < 8 and b < 8:
                dark_pinhole += 1
    opaque_ratio = round(sum(histogram[248:]) / float(w * h), 5)
    largest_ratio = largest_opaque_component_ratio(img)
    passed = (
        img.mode == "RGBA"
        and [w, h] == list(CANVAS)
        and nonzero > 500
        and all(a == 0 for a in corners)
        and all(v <= 0.01 for v in edge_ratios.values())
        and chroma == 0
        and dark_pinhole == 0
        and largest_ratio < 0.28
    )
    return {
        "normalization_mode": "local_vector_rgba_synthesis_real_alpha",
        "rgba_alpha": img.mode == "RGBA",
        "dimensions": [w, h],
        "alpha_bbox": bbox,
        "nonzero_alpha_pixels": nonzero,
        "visible_alpha_coverage": round(nonzero / float(w * h), 5),
        "transparent_corners": all(a == 0 for a in corners),
        "corner_alpha": corners,
        "edge_alpha_ratios": edge_ratios,
        "residue_scan": {
            "chroma_key_residue_pixels": chroma,
            "dark_pinhole_pixels": dark_pinhole,
            "edge_touch_sides_over_1pct": sum(1 for v in edge_ratios.values() if v > 0.01),
        },
        "background_block_check": {
            "opaque_pixel_ratio": opaque_ratio,
            "largest_opaque_component_ratio": largest_ratio,
            "large_background_block_risk": largest_ratio >= 0.28,
        },
        "pass": passed,
    }


def make_contact_sheet(paths: list[Path], labels: list[str]) -> Path:
    cols = 5
    rows = 2
    cell_w = 224
    cell_h = 236
    sheet = Image.new("RGBA", (cols * cell_w, rows * cell_h), (246, 242, 232, 255))
    d = ImageDraw.Draw(sheet, "RGBA")
    try:
        font = ImageFont.truetype("DejaVuSans.ttf", 14)
        small = ImageFont.truetype("DejaVuSans.ttf", 11)
    except OSError:
        font = ImageFont.load_default()
        small = font
    for index, path in enumerate(paths):
        x = (index % cols) * cell_w
        y = (index // cols) * cell_h
        d.rounded_rectangle((x + 8, y + 8, x + cell_w - 8, y + cell_h - 8), radius=8, fill=(255, 252, 244, 255), outline=(196, 181, 151, 255), width=1)
        tile = 16
        for cy in range(y + 22, y + 22 + 192, tile):
            for cx in range(x + 16, x + 16 + 192, tile):
                fill = (229, 225, 216, 255) if ((cx + cy) // tile) % 2 else (252, 249, 242, 255)
                d.rectangle((cx, cy, cx + tile - 1, cy + tile - 1), fill=fill)
        img = Image.open(path).convert("RGBA")
        sheet.alpha_composite(img, (x + 16, y + 22))
        label = labels[index]
        d.text((x + 14, y + 218), label[:28], fill=(73, 62, 52, 255), font=font)
        d.text((x + 14, y + 198), "192x192 RGBA proof-only", fill=(113, 101, 86, 255), font=small)
    out = PROOF / "round178_companion_care_props_contact_sheet.png"
    sheet.save(out)
    return out


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    PROOF.mkdir(parents=True, exist_ok=True)

    paths: list[Path] = []
    manifest_items = []
    for item in ITEMS:
        png = OUT / f"{item['slug']}.png"
        draw_item(item["slug"]).save(png)
        validation = validate_image(png)
        paths.append(png)
        manifest_items.append({
            "id": item["id"],
            "logical_asset_id": item["id"],
            "slug": item["slug"],
            "status": "pass" if validation["pass"] else "fail",
            "asset_status": "proof_only_transparent_candidate",
            "main_ref": str(png.relative_to(Path.cwd())),
            "normalized_png": str(png.relative_to(Path.cwd())),
            "dimensions": list(CANVAS),
            "pivot_recommendation_px": item["pivot"],
            "footprint_recommendation": item["footprint"],
            "layer_recommendation": item["layer"],
            "visual_style_notes": "child-safe cozy town companion-care prop, rounded proportions, warm Animal Crossing-like home/town scale, no text or brand marks",
            "generation_provenance": {
                "method": "local transparent RGBA vector/raster synthesis using Pillow",
                "raw_alpha_note": "No external RGB/opaque raw was used; real alpha is verified directly on the emitted PNG per LESSON-022.",
            },
            "validation": validation,
            "risks": [
                item["risk"],
                "Proof-only candidate; no runtime, ThemeProfile, AssetResolver, data, or shared-test mapping.",
                "Final art direction review is required before any production/runtime use.",
            ],
        })

    proof = make_contact_sheet(paths, [item["slug"] for item in ITEMS])
    pass_count = sum(1 for item in manifest_items if item["status"] == "pass")
    fail_count = len(manifest_items) - pass_count
    manifest = {
        "pack_id": "round178.companion_care_props",
        "round": "Round178",
        "worker": "Worker A",
        "status": "proof_only_transparent_candidates",
        "overall_gate": "pass" if fail_count == 0 else "fail",
        "runtime_boundary": RUNTIME_BOUNDARY,
        "category": "companion_care_props",
        "scope": "Ten child-safe cozy companion-care prop candidates only; no runtime mapping or production approval.",
        "compatibility_notes": [
            "Normalized to 192x192 transparent PNGs for small prop, inventory, and home companion-corner proof review.",
            "Designed with rounded warm proportions intended to sit near Sunny companion and home-interior candidate scale, pending composition review.",
        ],
        "generation_method": {
            "tool": "assets/art/visual_rebuild/round178/companion_care_props/generate_validate_manifest.py",
            "mode": "local transparent RGBA synthesis",
            "postprocess": "same script validates alpha/residue and writes manifest/contact sheet",
            "notes": "Per LESSON-022, final gate is based on actual RGBA alpha audit, not generator flags.",
        },
        "proof": str(proof.relative_to(Path.cwd())),
        "proofs": {
            "contact_sheet": str(proof.relative_to(Path.cwd())),
            "normalized_dir": str(OUT.relative_to(Path.cwd())),
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
            ],
            "pass_count": pass_count,
            "fail_count": fail_count,
            "raw_rgb_or_opaque_source_count": 0,
        },
        "items": manifest_items,
    }
    manifest_path = ROOT / "manifest.json"
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({
        "manifest": str(manifest_path.relative_to(Path.cwd())),
        "overall_gate": manifest["overall_gate"],
        "pass_count": pass_count,
        "fail_count": fail_count,
        "proof": str(proof.relative_to(Path.cwd())),
    }, indent=2))


if __name__ == "__main__":
    main()
