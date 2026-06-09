#!/usr/bin/env python3
from __future__ import annotations

import json
import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parent
OUT = ROOT / "candidates_256x256"
PROOF = ROOT / "proof"
CANVAS = (256, 256)
RUNTIME_BOUNDARY = "proof_only_no_runtime_mapping_no_themeprofile_no_assetresolver_no_data_changes"


ITEMS = [
    {
        "slug": "wallpaper_sun_dots",
        "asset_kind": "opaque_surface_swatch",
        "alpha_expectation": "intentional_opaque_surface",
        "surface_role": "wallpaper candidate",
        "risk": "Dot rhythm is decorative only; repeatability has not been audited.",
    },
    {
        "slug": "wallpaper_leaf_trail",
        "asset_kind": "opaque_surface_swatch",
        "alpha_expectation": "intentional_opaque_surface",
        "surface_role": "wallpaper candidate",
        "risk": "Leaf trail spacing is organic and proof-only; no tile seam/repeat claim.",
    },
    {
        "slug": "wallpaper_cloud_soft",
        "asset_kind": "opaque_surface_swatch",
        "alpha_expectation": "intentional_opaque_surface",
        "surface_role": "wallpaper candidate",
        "risk": "Large cloud shapes need room-scale review before use behind furniture.",
    },
    {
        "slug": "floor_wood_honey",
        "asset_kind": "opaque_surface_swatch",
        "alpha_expectation": "intentional_opaque_surface",
        "surface_role": "floor surface candidate",
        "risk": "Wood planks are hand-drawn proof swatches; runtime tiling was not audited.",
    },
    {
        "slug": "floor_soft_green_mat",
        "asset_kind": "transparent_cutout_mat",
        "alpha_expectation": "requires_real_rgba_alpha",
        "surface_role": "floor mat overlay candidate",
        "risk": "Rounded mat footprint may need scale review against home furniture.",
    },
    {
        "slug": "floor_blue_woven_mat",
        "asset_kind": "transparent_cutout_mat",
        "alpha_expectation": "requires_real_rgba_alpha",
        "surface_role": "floor mat overlay candidate",
        "risk": "Woven strokes are soft proof marks, not audited for repeat/tile use.",
    },
    {
        "slug": "rug_round_sun",
        "asset_kind": "transparent_cutout_rug",
        "alpha_expectation": "requires_real_rgba_alpha",
        "surface_role": "rug overlay candidate",
        "risk": "Circular rug needs runtime collision and furniture overlap review later.",
    },
    {
        "slug": "rug_leaf_runner",
        "asset_kind": "transparent_cutout_rug",
        "alpha_expectation": "requires_real_rgba_alpha",
        "surface_role": "rug runner overlay candidate",
        "risk": "Runner length is a visual proof size only; no placement footprint is mapped.",
    },
    {
        "slug": "curtain_morning_yellow",
        "asset_kind": "transparent_cutout_curtain",
        "alpha_expectation": "requires_real_rgba_alpha",
        "surface_role": "curtain overlay candidate",
        "risk": "Needs future window-size matching before runtime placement.",
    },
    {
        "slug": "curtain_mint_stripe",
        "asset_kind": "transparent_cutout_curtain",
        "alpha_expectation": "requires_real_rgba_alpha",
        "surface_role": "curtain overlay candidate",
        "risk": "Soft stripes are decorative only and contain no text or lesson marks.",
    },
    {
        "slug": "window_light_square",
        "asset_kind": "transparent_light_overlay",
        "alpha_expectation": "requires_real_rgba_alpha",
        "surface_role": "window light overlay candidate",
        "risk": "Blend mode and room exposure need later runtime visual review.",
    },
    {
        "slug": "shelf_backing_flower",
        "asset_kind": "opaque_surface_swatch",
        "alpha_expectation": "intentional_opaque_surface",
        "surface_role": "shelf backing swatch candidate",
        "risk": "Small flowers must remain low contrast behind shelf contents.",
    },
]


def sc(value, scale: int):
    if isinstance(value, tuple):
        return tuple(int(round(v * scale)) for v in value)
    return int(round(value * scale))


def draw_surface(slug: str) -> Image.Image:
    scale = 3
    transparent = slug not in {
        "wallpaper_sun_dots",
        "wallpaper_leaf_trail",
        "wallpaper_cloud_soft",
        "floor_wood_honey",
        "shelf_backing_flower",
    }
    mode = "RGBA" if transparent else "RGB"
    bg = (0, 0, 0, 0) if transparent else (250, 239, 214)
    img = Image.new(mode, (CANVAS[0] * scale, CANVAS[1] * scale), bg)
    d = ImageDraw.Draw(img, "RGBA")

    def rr(box, radius, fill, outline=None, width=1):
        d.rounded_rectangle(sc(box, scale), radius=sc(radius, scale), fill=fill, outline=outline, width=sc(width, scale))

    def ellipse(box, fill, outline=None, width=1):
        d.ellipse(sc(box, scale), fill=fill, outline=outline, width=sc(width, scale))

    def line(points, fill, width=1):
        d.line([sc(p, scale) for p in points], fill=fill, width=sc(width, scale), joint="curve")

    def poly(points, fill, outline=None):
        d.polygon([sc(p, scale) for p in points], fill=fill, outline=outline)

    if slug == "wallpaper_sun_dots":
        d.rectangle((0, 0, CANVAS[0] * scale, CANVAS[1] * scale), fill=(255, 244, 211, 255))
        for y in range(24, 256, 48):
            for x in range(24, 256, 48):
                ox = 8 if (y // 48) % 2 else 0
                ellipse((x + ox - 8, y - 8, x + ox + 8, y + 8), (244, 187, 84, 210))
                ellipse((x + ox - 3, y - 3, x + ox + 3, y + 3), (255, 227, 139, 255))
        for y in range(0, 256, 32):
            line([(0, y + 6), (256, y + 10)], (255, 235, 184, 95), 1)
    elif slug == "wallpaper_leaf_trail":
        d.rectangle((0, 0, CANVAS[0] * scale, CANVAS[1] * scale), fill=(239, 247, 221, 255))
        for i in range(-20, 285, 56):
            line([(i, 28), (i + 24, 58), (i + 42, 92), (i + 72, 124), (i + 96, 160), (i + 132, 206)], (139, 188, 125, 160), 3)
            for j in range(4):
                cx = i + 28 + j * 26
                cy = 56 + j * 34
                ellipse((cx - 8, cy - 4, cx + 10, cy + 8), (118, 181, 115, 205))
                ellipse((cx + 8, cy + 10, cx + 27, cy + 22), (157, 207, 139, 190))
        for y in range(0, 256, 42):
            line([(0, y), (256, y + 8)], (255, 250, 230, 90), 2)
    elif slug == "wallpaper_cloud_soft":
        d.rectangle((0, 0, CANVAS[0] * scale, CANVAS[1] * scale), fill=(224, 243, 245, 255))
        for x, y, w in [(18, 36, 76), (136, 70, 92), (54, 145, 110), (166, 184, 72), (-20, 214, 80)]:
            ellipse((x, y + 12, x + w, y + 48), (255, 252, 237, 235))
            ellipse((x + 16, y, x + 48, y + 34), (255, 252, 237, 245))
            ellipse((x + 42, y + 5, x + 78, y + 39), (255, 252, 237, 240))
        for y in range(18, 256, 52):
            line([(8, y), (92, y + 2), (180, y - 4), (248, y + 3)], (181, 219, 225, 88), 2)
    elif slug == "floor_wood_honey":
        d.rectangle((0, 0, CANVAS[0] * scale, CANVAS[1] * scale), fill=(231, 170, 93, 255))
        for y in range(0, 256, 43):
            d.rectangle(sc((0, y, 256, y + 40), scale), fill=(236, 181, 106, 255) if (y // 43) % 2 else (224, 158, 82, 255))
            line([(0, y + 41), (256, y + 39)], (151, 100, 54, 150), 2)
            for x in range((y // 43 % 3) * 34, 256, 86):
                line([(x, y + 5), (x + 31, y + 8), (x + 72, y + 3)], (255, 217, 143, 105), 2)
                line([(x + 12, y + 24), (x + 52, y + 28)], (128, 84, 46, 80), 1)
    elif slug == "floor_soft_green_mat":
        rr((22, 48, 234, 208), 32, (132, 197, 164, 248), (73, 126, 103, 245), 4)
        rr((38, 64, 218, 192), 25, (166, 221, 188, 235), (97, 154, 126, 190), 2)
        for y in range(78, 188, 22):
            line([(48, y), (207, y + math.sin(y) * 3)], (225, 247, 218, 132), 2)
        for x in range(58, 204, 36):
            ellipse((x - 7, 127, x + 7, 141), (108, 177, 139, 155))
    elif slug == "floor_blue_woven_mat":
        rr((18, 56, 238, 202), 26, (93, 161, 195, 248), (47, 99, 132, 245), 4)
        rr((33, 70, 223, 188), 20, (128, 196, 219, 232))
        for x in range(34, 196, 18):
            line([(x, 74), (x + 42, 188)], (226, 245, 240, 100), 3)
            line([(x + 28, 74), (x - 14, 188)], (66, 126, 160, 85), 2)
        for y in (67, 191):
            for x in range(38, 226, 16):
                line([(x, y), (x + 7, y)], (244, 235, 182, 175), 2)
    elif slug == "rug_round_sun":
        ellipse((31, 31, 225, 225), (239, 171, 81, 245), (145, 94, 48, 245), 5)
        ellipse((55, 55, 201, 201), (255, 214, 118, 238), (192, 126, 60, 180), 3)
        for angle in range(0, 360, 24):
            cx = 128 + math.cos(math.radians(angle)) * 58
            cy = 128 + math.sin(math.radians(angle)) * 58
            line([(128, 128), (cx, cy)], (226, 148, 62, 135), 3)
        ellipse((97, 97, 159, 159), (255, 235, 157, 230))
    elif slug == "rug_leaf_runner":
        rr((24, 72, 232, 184), 32, (214, 229, 169, 242), (108, 149, 86, 235), 4)
        line([(45, 128), (82, 105), (122, 126), (164, 104), (211, 129)], (94, 145, 86, 190), 4)
        for cx, cy, flip in [(74, 103, 1), (101, 126, -1), (139, 119, 1), (170, 101, -1), (197, 129, 1)]:
            ellipse((cx - 14, cy - 8, cx + 14, cy + 9), (131, 186, 106, 220))
            line([(cx - 10 * flip, cy + 8), (cx + 10 * flip, cy - 7)], (77, 126, 73, 130), 2)
        for x in range(44, 218, 20):
            line([(x, 75), (x + 8, 75)], (247, 241, 197, 155), 2)
            line([(x, 181), (x + 8, 181)], (247, 241, 197, 155), 2)
    elif slug == "curtain_morning_yellow":
        rr((42, 32, 214, 224), 18, (246, 202, 94, 236), (169, 122, 58, 230), 3)
        d.rectangle(sc((53, 40, 203, 219), scale), fill=(255, 222, 135, 226))
        line([(128, 36), (128, 224)], (184, 130, 61, 150), 4)
        for x in [67, 90, 166, 189]:
            line([(x, 42), (x + 8, 218)], (255, 244, 190, 95), 4)
        rr((34, 29, 222, 43), 7, (148, 106, 66, 248))
        ellipse((116, 125, 140, 148), (244, 176, 80, 220))
    elif slug == "curtain_mint_stripe":
        rr((43, 31, 213, 224), 18, (118, 197, 177, 236), (60, 118, 112, 230), 3)
        d.rectangle(sc((54, 41, 202, 220), scale), fill=(160, 224, 206, 224))
        line([(128, 36), (128, 224)], (53, 119, 112, 135), 4)
        for x in [68, 96, 160, 188]:
            line([(x, 40), (x + 9, 221)], (236, 250, 222, 135), 5)
        rr((35, 28, 221, 43), 7, (89, 128, 116, 248))
    elif slug == "window_light_square":
        rr((45, 43, 211, 213), 10, (255, 236, 152, 60))
        d.rectangle(sc((67, 65, 189, 191), scale), fill=(255, 244, 183, 74))
        line([(128, 51), (128, 205)], (255, 251, 210, 116), 5)
        line([(52, 128), (204, 128)], (255, 251, 210, 116), 5)
        for offset in [0, 20, 40]:
            line([(50 + offset, 214), (105 + offset, 151)], (255, 228, 127, 36), 8)
        ellipse((33, 33, 223, 223), (255, 238, 168, 22))
    elif slug == "shelf_backing_flower":
        d.rectangle((0, 0, CANVAS[0] * scale, CANVAS[1] * scale), fill=(245, 232, 210, 255))
        for y in range(28, 256, 52):
            for x in range(32, 256, 58):
                for dx, dy in [(0, -8), (8, 0), (0, 8), (-8, 0)]:
                    ellipse((x + dx - 6, y + dy - 5, x + dx + 6, y + dy + 6), (225, 151, 142, 165))
                ellipse((x - 4, y - 4, x + 4, y + 4), (236, 193, 91, 180))
                line([(x + 7, y + 8), (x + 18, y + 18)], (128, 172, 112, 115), 2)
        for y in range(0, 256, 64):
            line([(0, y + 5), (256, y + 1)], (222, 200, 171, 105), 1)

    img = img.resize(CANVAS, Image.Resampling.LANCZOS)
    if transparent:
        alpha = img.getchannel("A").point(lambda a: 0 if a < 18 else a)
        img.putalpha(alpha)
    return img


def validate_image(path: Path, item: dict) -> dict:
    img = Image.open(path)
    w, h = img.size
    expects_alpha = item["alpha_expectation"] == "requires_real_rgba_alpha"
    result = {
        "dimensions": [w, h],
        "asset_kind": item["asset_kind"],
        "alpha_expectation": item["alpha_expectation"],
        "repeatability_audited": False,
        "runtime_tiling_claim": False,
    }
    if expects_alpha:
        rgba = img.convert("RGBA")
        alpha = rgba.getchannel("A")
        hist = alpha.histogram()
        nonzero = sum(hist[1:])
        transparent = hist[0]
        bbox = alpha.getbbox()
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
        pixel_data = rgba.get_flattened_data() if hasattr(rgba, "get_flattened_data") else rgba.getdata()
        for r, g, b, a in pixel_data:
            if a > 0 and ((g > 235 and r < 30 and b < 30) or (r > 235 and b > 235 and g < 30)):
                chroma += 1
        result.update({
            "rgba_alpha": rgba.mode == "RGBA",
            "real_alpha_channel": True,
            "alpha_bbox": list(bbox) if bbox else None,
            "nonzero_alpha_pixels": nonzero,
            "transparent_pixel_count": transparent,
            "transparent_corners": all(a == 0 for a in corners),
            "corner_alpha": corners,
            "visible_alpha_coverage": round(nonzero / float(w * h), 5),
            "edge_alpha_ratios": edge_ratios,
            "chroma_key_residue_pixels": chroma,
            "intentional_opaque_surface": False,
            "pass": (
                img.mode == "RGBA"
                and [w, h] == list(CANVAS)
                and nonzero > 1000
                and transparent > 1000
                and all(a == 0 for a in corners)
                and all(value <= 0.01 for value in edge_ratios.values())
                and chroma == 0
            ),
        })
    else:
        rgb = img.convert("RGBA")
        alpha = rgb.getchannel("A")
        hist = alpha.histogram()
        result.update({
            "rgba_alpha": img.mode == "RGBA",
            "real_alpha_channel": False,
            "intentional_opaque_surface": True,
            "all_pixels_opaque": hist[255] == w * h,
            "opaque_pixel_count": hist[255],
            "transparent_pixel_count": hist[0],
            "pass": [w, h] == list(CANVAS) and hist[255] == w * h,
        })
    return result


def make_contact_sheet(paths: list[Path], items: list[dict]) -> Path:
    cols = 4
    rows = 3
    cell_w = 296
    cell_h = 326
    sheet = Image.new("RGBA", (cols * cell_w, rows * cell_h), (242, 238, 226, 255))
    d = ImageDraw.Draw(sheet, "RGBA")
    try:
        font = ImageFont.truetype("DejaVuSans.ttf", 15)
        small = ImageFont.truetype("DejaVuSans.ttf", 11)
    except OSError:
        font = ImageFont.load_default()
        small = font
    for index, path in enumerate(paths):
        x = (index % cols) * cell_w
        y = (index // cols) * cell_h
        d.rounded_rectangle((x + 10, y + 10, x + cell_w - 10, y + cell_h - 10), radius=8, fill=(255, 252, 244, 255), outline=(189, 175, 145, 255), width=1)
        tile = 16
        for cy in range(y + 23, y + 23 + 256, tile):
            for cx in range(x + 20, x + 20 + 256, tile):
                fill = (225, 221, 212, 255) if ((cx + cy) // tile) % 2 else (250, 247, 240, 255)
                d.rectangle((cx, cy, cx + tile - 1, cy + tile - 1), fill=fill)
        img = Image.open(path).convert("RGBA")
        sheet.alpha_composite(img, (x + 20, y + 23))
        d.text((x + 18, y + 286), items[index]["slug"], fill=(70, 58, 48, 255), font=font)
        d.text((x + 18, y + 306), items[index]["asset_kind"], fill=(112, 96, 76, 255), font=small)
    out = PROOF / "round179_home_decor_surfaces_contact_sheet.png"
    sheet.save(out)
    return out


def rel(path: Path) -> str:
    return str(path.relative_to(Path.cwd()))


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    PROOF.mkdir(parents=True, exist_ok=True)

    paths: list[Path] = []
    manifest_items: list[dict] = []
    for item in ITEMS:
        path = OUT / f"{item['slug']}.png"
        draw_surface(item["slug"]).save(path)
        validation = validate_image(path, item)
        paths.append(path)
        manifest_items.append({
            "id": f"home_decor_surfaces.{item['slug']}",
            "suggested_id": item["slug"],
            "logical_asset_id": None,
            "slug": item["slug"],
            "status": "pass" if validation["pass"] else "fail",
            "asset_status": "proof_only_candidate",
            "asset_kind": item["asset_kind"],
            "alpha_expectation": item["alpha_expectation"],
            "main_ref": rel(path),
            "normalized_png": rel(path),
            "dimensions": list(CANVAS),
            "surface_role": item["surface_role"],
            "visual_style_notes": "child-safe cozy home decor surface candidate, no text, no classroom/test motif, no hard grid; future home decoration proof only",
            "generation_provenance": {
                "method": "local Pillow RGBA/RGB synthesis",
                "alpha_note": "Alpha/opacity is verified from actual emitted pixels per LESSON-022.",
            },
            "validation": validation,
            "risks": [
                item["risk"],
                "Proof-only candidate; no runtime, ThemeProfile, AssetResolver, data, art_target_locked, runtime_visual_match, or shared-test mapping.",
                "Final art direction and room-scale composition review are required before any production/runtime use.",
            ],
        })

    proof = make_contact_sheet(paths, ITEMS)
    pass_count = sum(1 for item in manifest_items if item["status"] == "pass")
    fail_count = len(manifest_items) - pass_count
    manifest = {
        "pack_id": "round179.home_decor_surfaces",
        "round": "Round179",
        "worker": "Worker A",
        "status": "proof_only_home_decor_surface_candidates",
        "overall_gate": "pass" if fail_count == 0 else "fail",
        "runtime_boundary": RUNTIME_BOUNDARY,
        "category": "home_decor_surfaces",
        "scope": "12 cozy child-safe home decor surface candidates only: wallpapers, floor mats, rugs, curtains, window light overlay, and shelf backing swatch.",
        "non_scope": [
            "no runtime wiring",
            "no ThemeProfile",
            "no AssetResolver",
            "no data mapping",
            "no art_target_locked",
            "no runtime_visual_match",
            "no runtime/data/shared test/todo/lessons changes",
        ],
        "generation_method": {
            "tool": "assets/art/visual_rebuild/round179/home_decor_surfaces/generate_validate_pack.py",
            "mode": "local proof-only RGB/RGBA synthesis",
            "postprocess": "same script writes PNGs, validates pixel opacity/alpha, and builds contact sheet",
            "notes": "Per LESSON-022, final gate is based on actual pixel properties. Opaque swatches record intentional_opaque_surface=true; overlays require real RGBA alpha.",
        },
        "proof": rel(proof),
        "proofs": {
            "contact_sheet": rel(proof),
            "candidate_dir": rel(OUT),
        },
        "validation_summary": {
            "checks": [
                "expected 256x256 dimensions",
                "opaque swatches: all pixels opaque and intentional_opaque_surface=true",
                "overlays: PNG mode RGBA with real transparent pixels and nonzero visible alpha",
                "overlays: transparent corners",
                "overlays: no edge-touching alpha over 1 percent per side",
                "overlays: no green/magenta chroma-key residue",
                "no runtime tiling or repeatability claim",
            ],
            "pass_count": pass_count,
            "fail_count": fail_count,
            "opaque_surface_count": sum(1 for item in manifest_items if item["validation"]["intentional_opaque_surface"]),
            "real_alpha_overlay_count": sum(1 for item in manifest_items if item["validation"]["real_alpha_channel"]),
        },
        "items": manifest_items,
    }
    manifest_path = ROOT / "manifest.json"
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({
        "manifest": rel(manifest_path),
        "overall_gate": manifest["overall_gate"],
        "pass_count": pass_count,
        "fail_count": fail_count,
        "proof": rel(proof),
    }, indent=2))


if __name__ == "__main__":
    main()
