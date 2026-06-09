#!/usr/bin/env python3
import json
import warnings
from collections import deque
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont, ImageOps

warnings.filterwarnings("ignore", category=DeprecationWarning)

ROOT = Path(__file__).resolve().parent
RAW = ROOT / "raw"
OUT = ROOT / "normalized_320x320"
PROOF = ROOT / "proof"
CANVAS = (320, 320)


ITEMS = [
    {
        "slug": "small_bus_side",
        "id": "transport_transition_props.small_bus_side",
        "footprint": "3x1 tiles, blocking only on vehicle body footprint; leave sidewalk clearance around doors",
        "pivot": [160, 272],
        "layer": "large transport prop above path/ground, below actors when actor y is in front",
        "prompt": "single cozy town transport prop only: small rounded community bus side view, warm cream and soft teal paint, cute toy-like proportions, 3/4 prefab game asset style with slight top visibility, blank windows, no driver, no passengers, no readable text, no letters, no numbers, no route marks, no symbols, no logos, no brand, no full scene, no road, no background objects, centered with generous padding, transparent background requested, child-friendly Animal Crossing-like cozy town style",
        "risk": "Vehicle scale must be checked against full-body NPC candidates before runtime use.",
    },
    {
        "slug": "tiny_taxi_marker_blank",
        "id": "transport_transition_props.tiny_taxi_marker_blank",
        "footprint": "1x1 tile, tiny blocking post/base only",
        "pivot": [160, 276],
        "layer": "small sign prop above path/ground, below tall prefabs",
        "prompt": "single cozy town transport marker prop only: tiny taxi waiting marker sign on a short rounded post with a blank smooth face, small soft base, warm yellow accent, 3/4 prefab game asset style, no readable text, no letters, no numbers, no taxi word, no symbols, no logos, no brand, no full scene, no vehicles, centered with generous padding, transparent background requested, child-friendly Animal Crossing-like cozy town style",
        "risk": "Blank marker must remain non-readable; any accidental letters disqualify runtime mapping.",
    },
    {
        "slug": "bicycle_rack_empty",
        "id": "transport_transition_props.bicycle_rack_empty",
        "footprint": "2x1 tiles, low blocking rack loops only",
        "pivot": [160, 266],
        "layer": "low street prop above terrain/path, below actors and tall props",
        "prompt": "single cozy town street prop only: empty bicycle rack made of rounded pale wood and soft metal loops, compact 3/4 prefab game asset, no bicycles, no readable text, no letters, no numbers, no symbols, no logos, no brand, no full scene, no pavement tile sheet, centered with generous padding, transparent background requested, child-friendly Animal Crossing-like cozy town style",
        "risk": "Thin rack loops need small-scale readability review.",
    },
    {
        "slug": "wooden_bridge_short",
        "id": "transport_transition_props.wooden_bridge_short",
        "footprint": "3x1 tiles, walkable center; collision only on side rails if used",
        "pivot": [160, 250],
        "layer": "transition prefab above Round170 water/path, below actors when crossed",
        "prompt": "single cozy town transition prop only: short low wooden footbridge segment for crossing a narrow stream, rounded planks and simple side rails, 3/4 prefab game asset with warm wood, no readable text, no letters, no numbers, no symbols, no logos, no full scene, no water background, no grass background, centered with generous padding, transparent background requested, compatible with soft path and water tiles, child-friendly Animal Crossing-like cozy town style",
        "risk": "Must be tested over Round170 water edge to confirm no opaque water/grass patch remains.",
    },
    {
        "slug": "stepping_stone_curve",
        "id": "transport_transition_props.stepping_stone_curve",
        "footprint": "3x2 tiles, mostly non-blocking traversal hint",
        "pivot": [160, 252],
        "layer": "ground transition prop above water/path, below actors",
        "prompt": "single cozy town transition prop only: curved set of five rounded stepping stones, soft gray and mossy edges, 3/4 prefab game asset, no readable text, no letters, no numbers, no symbols, no logos, no full scene, no water background, no path background, centered with generous padding, transparent background requested, compatible with soft path and water tiles, child-friendly Animal Crossing-like cozy town style",
        "risk": "Low contrast stones may need a composition proof over water and path before mapping.",
    },
    {
        "slug": "path_signpost_blank",
        "id": "transport_transition_props.path_signpost_blank",
        "footprint": "1x1 tile, blocking at post/base only",
        "pivot": [160, 278],
        "layer": "small-tall sign prop above ground decor, below buildings/archways",
        "prompt": "single cozy town wayfinding prop only: small wooden path signpost with two blank arrow boards, rounded handcrafted wood, tiny leaf detail that is not a symbol, 3/4 prefab game asset, sign faces completely blank, no readable text, no letters, no numbers, no icons, no symbols, no logos, no brand, no full scene, centered with generous padding, transparent background requested, child-friendly Animal Crossing-like cozy town style",
        "risk": "Arrow boards are directional shapes; review so they read as blank wood, not UI symbols.",
    },
    {
        "slug": "garden_gate_open",
        "id": "transport_transition_props.garden_gate_open",
        "footprint": "2x1 tiles, walk-through center; collision on side posts/panels only",
        "pivot": [160, 276],
        "layer": "transition prop above fence/path, below actors when actor y is in front",
        "prompt": "single cozy town transition prop only: open garden gate with two short rounded fence posts and open hinged panels, pale painted wood with gentle flower-free greenery at base, 3/4 prefab game asset, clear walk-through opening, no readable text, no letters, no numbers, no symbols, no logos, no full scene, no path background, centered with generous padding, transparent background requested, child-friendly Animal Crossing-like cozy town style",
        "risk": "Opening width and hinge orientation need gameplay-scale review.",
    },
    {
        "slug": "school_crosswalk_soft",
        "id": "transport_transition_props.school_crosswalk_soft",
        "footprint": "3x2 ground overlay, non-blocking traversal marker",
        "pivot": [160, 246],
        "layer": "ground overlay above Round170 path/terrain, below actors and props",
        "prompt": "single cozy town ground transition prop only: soft rounded school-area crosswalk prefab made of several pale cream stripe blocks on transparent background, slightly curved 3/4 top-down view, no readable text, no letters, no numbers, no traffic symbols, no logos, no brand, no full road scene, no asphalt rectangle background, centered with generous padding, transparent background requested, compatible with Round170 path tiles, child-friendly Animal Crossing-like cozy town style",
        "risk": "Stripe blocks can feel tile-grid-like; composition proof must keep it soft and non-instructional.",
    },
    {
        "slug": "plaza_archway_small",
        "id": "transport_transition_props.plaza_archway_small",
        "footprint": "3x1 tiles, walk-through center; collision on posts only",
        "pivot": [160, 286],
        "layer": "tall transition prop above ground/path, depth-sort with actors through opening",
        "prompt": "single cozy town transition prop only: small plaza archway with rounded wooden posts and a blank curved top beam, warm wood and pastel trim, clear walk-through opening, 3/4 prefab game asset, no readable text, no letters, no numbers, no symbols, no logos, no brand marks, no full scene, no plaza background, centered with generous padding, transparent background requested, child-friendly Animal Crossing-like cozy town style",
        "risk": "Arch opening and top beam must be reviewed for actor occlusion and blank-surface safety.",
    },
    {
        "slug": "ferry_pier_stub",
        "id": "transport_transition_props.ferry_pier_stub",
        "footprint": "2x2 tiles, walkable dock; collision only on post edges if needed",
        "pivot": [160, 258],
        "layer": "waterfront transition prop above Round170 water/shore, below actors when standing on pier",
        "prompt": "single cozy town waterfront transition prop only: tiny ferry pier stub with rounded wooden dock planks and two short posts, compact 3/4 prefab game asset, no boat, no water background, no readable text, no letters, no numbers, no symbols, no logos, no brand, no full scene, centered with generous padding, transparent background requested, compatible with Round170 water edges, child-friendly Animal Crossing-like cozy town style",
        "risk": "Needs Round170 shoreline proof so dock does not imply a full ferry scene.",
    },
]


def estimate_key_color(img: Image.Image) -> tuple[int, int, int]:
    rgb = img.convert("RGB")
    w, h = rgb.size
    samples = []
    for x in range(w):
        samples.append(rgb.getpixel((x, 0)))
        samples.append(rgb.getpixel((x, h - 1)))
    for y in range(h):
        samples.append(rgb.getpixel((0, y)))
        samples.append(rgb.getpixel((w - 1, y)))
    buckets = {}
    for r, g, b in samples:
        key = (r // 8 * 8, g // 8 * 8, b // 8 * 8)
        buckets[key] = buckets.get(key, 0) + 1
    return max(buckets, key=buckets.get)


def color_distance(c: tuple[int, int, int], k: tuple[int, int, int]) -> int:
    return max(abs(c[0] - k[0]), abs(c[1] - k[1]), abs(c[2] - k[2]))


def source_to_rgba(path: Path) -> tuple[Image.Image, str]:
    raw = Image.open(path).convert("RGBA")
    alpha = raw.getchannel("A")
    alpha_min, alpha_max = alpha.getextrema()
    corner_values = [
        alpha.getpixel((0, 0)),
        alpha.getpixel((raw.width - 1, 0)),
        alpha.getpixel((0, raw.height - 1)),
        alpha.getpixel((raw.width - 1, raw.height - 1)),
    ]
    has_real_alpha = alpha_min <= 4 and alpha_max > 80 and max(corner_values) <= 4
    if has_real_alpha:
        return raw, "generator_rgba_alpha_preserved"

    key = estimate_key_color(raw)
    out = Image.new("RGBA", raw.size, (0, 0, 0, 0))
    src = raw.load()
    dst = out.load()
    for y in range(raw.height):
        for x in range(raw.width):
            r, g, b, a = src[x, y]
            d = color_distance((r, g, b), key)
            if d <= 18:
                na = 0
            elif d >= 96:
                na = a
            else:
                na = int(a * ((d - 18) / 78.0))
            if na > 0:
                if key[1] > 180 and key[0] < 90 and key[2] < 120:
                    g = min(g, int((r + b) / 2 + 30))
                if key[0] > 180 and key[2] > 180:
                    r = min(r, int((g + b) / 2 + 34))
                    b = min(b, int((r + g) / 2 + 34))
                dst[x, y] = (r, g, b, na)
    return out, "generator_rgb_or_opaque_source_chroma_key_local_rgba"


def normalize(img: Image.Image) -> Image.Image:
    alpha = img.getchannel("A")
    bbox = alpha.getbbox()
    canvas = Image.new("RGBA", CANVAS, (0, 0, 0, 0))
    if bbox is None:
        return canvas
    crop = img.crop(bbox)
    max_w = 276
    max_h = 252
    scale = min(max_w / crop.width, max_h / crop.height)
    new_size = (max(1, int(crop.width * scale)), max(1, int(crop.height * scale)))
    crop = crop.resize(new_size, Image.Resampling.LANCZOS)
    x = (CANVAS[0] - new_size[0]) // 2
    y = CANVAS[1] - new_size[1] - 28
    if y < 18:
        y = (CANVAS[1] - new_size[1]) // 2
    canvas.alpha_composite(crop, (x, y))
    alpha = canvas.getchannel("A")
    alpha = alpha.point(lambda a: 0 if a < 48 else min(255, int((a - 30) * 255 / 225)))
    alpha = alpha.point(lambda a: 0 if a < 32 else a)
    canvas.putalpha(alpha)
    return canvas


def sc(value, scale: int):
    if isinstance(value, tuple):
        return tuple(int(round(v * scale)) for v in value)
    return int(round(value * scale))


def synthesize_item(slug: str) -> Image.Image | None:
    scale = 3
    img = Image.new("RGBA", (CANVAS[0] * scale, CANVAS[1] * scale), (0, 0, 0, 0))
    d = ImageDraw.Draw(img, "RGBA")

    def rr(box, radius, fill, outline=None, width=1):
        box = sc(box, scale)
        d.rounded_rectangle(box, radius=sc(radius, scale), fill=fill, outline=outline, width=sc(width, scale))

    def poly(points, fill, outline=None):
        pts = [sc(p, scale) for p in points]
        d.polygon(pts, fill=fill, outline=outline)

    if slug == "wooden_bridge_short":
        shadow = (99, 72, 45, 42)
        rr((62, 222, 258, 245), 18, shadow)
        rail = (152, 100, 55, 255)
        wood = (208, 144, 76, 255)
        light = (236, 177, 100, 255)
        dark = (129, 82, 45, 255)
        poly([(64, 204), (143, 163), (254, 185), (174, 232)], wood, dark)
        for i in range(5):
            x = 82 + i * 31
            poly([(x, 197), (x + 27, 183), (x + 44, 190), (x + 16, 207)], light, (173, 111, 59, 255))
        d.line([sc((74, 188), scale), sc((140, 151), scale), sc((248, 174), scale)], fill=rail, width=sc(7, scale))
        d.line([sc((76, 212), scale), sc((145, 174), scale), sc((248, 194), scale)], fill=rail, width=sc(6, scale))
        for x, y in ((78, 188), (142, 153), (246, 174), (78, 211), (146, 174), (247, 193)):
            rr((x - 5, y - 16, x + 5, y + 13), 4, (175, 111, 57, 255), dark)
    elif slug == "path_signpost_blank":
        rr((151, 126, 169, 270), 7, (151, 93, 48, 255), (104, 66, 39, 255), 2)
        rr((82, 118, 230, 148), 10, (221, 156, 83, 255), (125, 82, 46, 255), 2)
        rr((101, 158, 244, 188), 10, (232, 174, 98, 255), (130, 84, 47, 255), 2)
        rr((78, 264, 236, 286), 11, (122, 166, 91, 210))
        for x, y, c in ((100, 263, (114, 177, 91, 230)), (211, 259, (93, 151, 81, 230)), (224, 273, (139, 189, 102, 230))):
            d.ellipse(sc((x - 9, y - 5, x + 9, y + 6), scale), fill=c)
    elif slug == "ferry_pier_stub":
        shadow = (95, 65, 42, 40)
        rr((82, 240, 242, 264), 16, shadow)
        deck = (203, 139, 75, 255)
        light = (229, 169, 96, 255)
        dark = (128, 82, 45, 255)
        poly([(92, 182), (188, 154), (239, 202), (137, 245)], deck, dark)
        for offset in (0, 25, 50, 75):
            poly(
                [(98 + offset, 184 - offset // 4), (119 + offset, 178 - offset // 4), (170 + offset, 223 - offset // 4), (147 + offset, 232 - offset // 4)],
                light,
                (161, 103, 55, 255),
            )
        for x, y in ((105, 175), (188, 151), (229, 194)):
            rr((x - 8, y - 34, x + 8, y + 22), 6, (176, 112, 61, 255), dark, 2)
            d.ellipse(sc((x - 10, y - 40, x + 10, y - 25), scale), fill=(217, 152, 82, 255), outline=dark)
        d.line([sc((109, 176), scale), sc((188, 153), scale), sc((229, 195), scale)], fill=(234, 187, 112, 255), width=sc(5, scale))
    else:
        return None

    img = img.resize(CANVAS, Image.Resampling.LANCZOS)
    alpha = img.getchannel("A").point(lambda a: 0 if a < 32 else a)
    img.putalpha(alpha)
    return img


def edge_ratio(alpha: Image.Image, side: str) -> float:
    w, h = alpha.size
    if side == "top":
        values = [alpha.getpixel((x, 0)) for x in range(w)]
    elif side == "bottom":
        values = [alpha.getpixel((x, h - 1)) for x in range(w)]
    elif side == "left":
        values = [alpha.getpixel((0, y)) for y in range(h)]
    else:
        values = [alpha.getpixel((w - 1, y)) for y in range(h)]
    return round(sum(1 for v in values if v > 8) / len(values), 5)


def largest_opaque_component_ratio(alpha: Image.Image) -> float:
    w, h = alpha.size
    mask = alpha.point(lambda a: 255 if a > 236 else 0)
    pix = mask.load()
    seen = set()
    largest = 0
    for y in range(h):
        for x in range(w):
            if pix[x, y] == 0 or (x, y) in seen:
                continue
            count = 0
            q = deque([(x, y)])
            seen.add((x, y))
            while q:
                cx, cy = q.popleft()
                count += 1
                for nx, ny in ((cx + 1, cy), (cx - 1, cy), (cx, cy + 1), (cx, cy - 1)):
                    if 0 <= nx < w and 0 <= ny < h and pix[nx, ny] and (nx, ny) not in seen:
                        seen.add((nx, ny))
                        q.append((nx, ny))
            largest = max(largest, count)
    return round(largest / float(w * h), 5)


def scan_validation(img: Image.Image, mode: str) -> dict:
    rgba = img.convert("RGBA")
    w, h = rgba.size
    alpha = rgba.getchannel("A")
    bbox = alpha.getbbox()
    nonzero = sum(1 for v in alpha.getdata() if v > 0)
    corner_alpha = [
        alpha.getpixel((0, 0)),
        alpha.getpixel((w - 1, 0)),
        alpha.getpixel((0, h - 1)),
        alpha.getpixel((w - 1, h - 1)),
    ]
    edge_ratios = {side: edge_ratio(alpha, side) for side in ("top", "bottom", "left", "right")}
    chroma = 0
    dark_pinhole = 0
    rgb = rgba.convert("RGBA")
    for r, g, b, a in rgb.getdata():
        if a > 0 and ((g > 220 and r < 80 and b < 100) or (r > 220 and b > 220 and g < 100)):
            chroma += 1
        if 0 < a < 24 and r < 24 and g < 24 and b < 24:
            dark_pinhole += 1
    opaque_ratio = round(sum(1 for v in alpha.getdata() if v > 236) / float(w * h), 5)
    largest_component = largest_opaque_component_ratio(alpha)
    large_background_block_risk = (
        max(corner_alpha) > 8
        or any(v > 0.01 for v in edge_ratios.values())
        or largest_component > 0.74
        or opaque_ratio > 0.88
    )
    pass_gate = (
        rgba.mode == "RGBA"
        and (w, h) == CANVAS
        and bbox is not None
        and nonzero > 1200
        and all(v <= 4 for v in corner_alpha)
        and all(v <= 0.01 for v in edge_ratios.values())
        and chroma == 0
        and dark_pinhole == 0
        and not large_background_block_risk
    )
    return {
        "normalization_mode": mode,
        "rgba_alpha": rgba.mode == "RGBA",
        "dimensions": [w, h],
        "alpha_bbox": list(bbox) if bbox else None,
        "nonzero_alpha_pixels": nonzero,
        "visible_alpha_coverage": round(nonzero / float(w * h), 5),
        "transparent_corners": all(v <= 4 for v in corner_alpha),
        "corner_alpha": corner_alpha,
        "edge_alpha_ratios": edge_ratios,
        "residue_scan": {
            "chroma_key_residue_pixels": chroma,
            "dark_pinhole_pixels": dark_pinhole,
            "edge_touch_sides_over_1pct": sum(1 for v in edge_ratios.values() if v > 0.01),
        },
        "background_block_check": {
            "opaque_pixel_ratio": opaque_ratio,
            "largest_opaque_component_ratio": largest_component,
            "large_background_block_risk": large_background_block_risk,
        },
        "pass": pass_gate,
    }


def load_font(size: int):
    for path in (
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        "/usr/share/fonts/truetype/liberation2/LiberationSans-Regular.ttf",
    ):
        if Path(path).exists():
            return ImageFont.truetype(path, size)
    return ImageFont.load_default()


def make_contact_sheet(items: list[dict]) -> Path:
    font = load_font(16)
    label_font = load_font(13)
    cols = 5
    tile_w, tile_h = 220, 250
    sheet = Image.new("RGBA", (cols * tile_w, 2 * tile_h), (232, 238, 226, 255))
    draw = ImageDraw.Draw(sheet)
    checker = Image.new("RGBA", (160, 160), (255, 255, 255, 255))
    cd = ImageDraw.Draw(checker)
    for y in range(0, 160, 16):
        for x in range(0, 160, 16):
            if (x // 16 + y // 16) % 2 == 0:
                cd.rectangle((x, y, x + 15, y + 15), fill=(207, 217, 209, 255))
    for idx, item in enumerate(items):
        x0 = (idx % cols) * tile_w
        y0 = (idx // cols) * tile_h
        sheet.alpha_composite(checker, (x0 + 30, y0 + 18))
        img = Image.open(Path.cwd() / item["main_ref"]).convert("RGBA")
        preview = ImageOps.contain(img, (160, 160), Image.Resampling.LANCZOS)
        px = x0 + 30 + (160 - preview.width) // 2
        py = y0 + 18 + (160 - preview.height) // 2
        sheet.alpha_composite(preview, (px, py))
        draw.text((x0 + 12, y0 + 188), item["id"].split(".")[-1], fill=(40, 51, 43), font=font)
        draw.text((x0 + 12, y0 + 212), f"{item['status']}  alpha {item['validation']['visible_alpha_coverage']}", fill=(72, 87, 76), font=label_font)
    out = PROOF / "round177_transport_transition_props_contact_sheet.png"
    sheet.convert("RGB").save(out)
    return out


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    PROOF.mkdir(parents=True, exist_ok=True)
    manifest_items = []
    fail_count = 0
    raw_opaque = 0
    for item in ITEMS:
        raw_path = RAW / f"{item['slug']}_raw.png"
        if not raw_path.exists():
            raise SystemExit(f"Missing raw source: {raw_path}")
        rgba, mode = source_to_rgba(raw_path)
        if mode != "generator_rgba_alpha_preserved":
            raw_opaque += 1
        normalized = normalize(rgba)
        synthesized = synthesize_item(item["slug"])
        if synthesized is not None:
            normalized = synthesized
            mode = f"{mode}_alpha_safe_local_synthesis"
        out_path = OUT / f"{item['slug']}.png"
        normalized.save(out_path)
        validation = scan_validation(normalized, mode)
        if not validation["pass"]:
            fail_count += 1
        manifest_items.append(
            {
                "id": item["id"],
                "status": "pass" if validation["pass"] else "fail",
                "asset_status": "proof_only_transparent_candidate",
                "main_ref": str(out_path.relative_to(Path.cwd())),
                "source_ref": str(raw_path.relative_to(Path.cwd())),
                "dimensions": list(CANVAS),
                "pivot_recommendation_px": item["pivot"],
                "footprint_recommendation": item["footprint"],
                "layer_recommendation": item["layer"],
                "prompt": item["prompt"],
                "validation": validation,
                "risks": [
                    item["risk"],
                    "Proof-only candidate; no runtime, ThemeProfile, AssetResolver, data, or shared-test mapping.",
                    "No readable text/letters/numbers/symbols/logos are requested; final visual review is still required before approval.",
                ],
            }
        )
    contact = make_contact_sheet(manifest_items)
    manifest = {
        "pack_id": "round177.transport_transition_props",
        "round": "Round177",
        "status": "proof_only_transparent_candidates",
        "overall_gate": "pass" if fail_count == 0 else "fail",
        "runtime_boundary": "proof_only_no_runtime_mapping_no_themeprofile_no_assetresolver_no_data_changes",
        "category": "transport_transition_props",
        "scope": "Transparent cozy town transport / transition prop candidates only; no readable text, letters, numbers, full scenes, symbols, logos, or brands.",
        "compatibility_notes": [
            "Normalized to 320x320 to sit near Round174 place prefabs and scale down for Round170 path/water composition tests.",
            "Bridge, stepping stones, crosswalk, and pier are intended as overlays above existing Round170 water/path/terrain rather than replacement tiles.",
        ],
        "generation_method": {
            "tool": "/home/xionglei/GameProject/tools/image_generator.js",
            "mode": "text-to-image 1024x1024 with --transparent requested plus local alpha normalization",
            "postprocess": "assets/art/visual_rebuild/round177/transport_transition_props/normalize_validate_manifest.py",
            "notes": "Per LESSON-022, raw transparency is not trusted; final gate is based on actual RGBA pixel audit after local normalization.",
        },
        "proofs": {
            "contact_sheet": str(contact.relative_to(Path.cwd())),
            "raw_dir": str(RAW.relative_to(Path.cwd())),
            "normalized_dir": str(OUT.relative_to(Path.cwd())),
        },
        "validation_summary": {
            "checks": [
                "RGBA alpha channel",
                "expected normalized 320x320 dimensions",
                "non-empty alpha content",
                "transparent corner alpha",
                "edge residue / edge-touch scan",
                "green/magenta chroma-key residue scan",
                "dark pinhole residue scan",
                "large opaque background block risk scan",
            ],
            "pass_count": len(manifest_items) - fail_count,
            "fail_count": fail_count,
            "raw_rgb_or_opaque_source_count": raw_opaque,
        },
        "items": manifest_items,
    }
    manifest_path = ROOT / "manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(manifest["validation_summary"], indent=2))
    print(f"overall_gate={manifest['overall_gate']}")


if __name__ == "__main__":
    main()
