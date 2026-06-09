#!/usr/bin/env python3
import json
import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parent
RAW = ROOT / "raw"
OUT = ROOT / "normalized_192x192"
PROOF = ROOT / "proof"
CANVAS = (192, 192)


ITEMS = [
    {
        "slug": "branch_pile_node",
        "category": "world_resource_node",
        "prompt": "single transparent cozy town resource node prop: a small rounded pile of friendly fallen branches and twigs tied by soft leaves, Animal Crossing-like soft 3/4 game prop style, child-friendly, warm handmade shapes, centered with generous padding, no readable text, no letters, no numbers, no UI card, no full scene, no characters, no reward symbol, flat solid #00ff00 chroma key background only, no cast shadow on background",
        "key_hint": [0, 255, 0],
        "pivot": [96, 166],
        "footprint": "1x1 tile, low blocking/collectible footprint centered around base",
        "layer": "ground resource prop above terrain/path, below actors when actor y is in front",
        "risk": "Brown branches need contrast check on warm dirt paths."
    },
    {
        "slug": "pebble_cluster_node",
        "category": "world_resource_node",
        "prompt": "single transparent cozy town resource node prop: a compact cluster of smooth rounded pebbles with tiny moss accents, Animal Crossing-like soft 3/4 game prop style, child-friendly, centered with generous padding, no readable text, no letters, no numbers, no UI card, no full scene, no characters, no reward symbol, flat solid #ff00ff chroma key background only, no cast shadow on background",
        "key_hint": [255, 0, 255],
        "pivot": [96, 168],
        "footprint": "1x1 tile, low mostly non-blocking collectible marker",
        "layer": "ground resource prop above terrain/path, below actors and taller decor",
        "risk": "Low gray silhouette may need edge contrast on stone paths."
    },
    {
        "slug": "wildflower_collect_patch",
        "category": "world_resource_node",
        "prompt": "single transparent cozy town resource node prop: a small collectable patch of wildflowers and soft grass, rounded pastel petals, Animal Crossing-like soft 3/4 game prop style, child-friendly, centered with generous padding, no readable text, no letters, no numbers, no UI card, no full scene, no characters, no reward symbol, flat solid #ff00ff chroma key background only, no cast shadow on background",
        "key_hint": [255, 0, 255],
        "pivot": [96, 168],
        "footprint": "1x1 tile, non-blocking low collect patch",
        "layer": "ground flora resource above grass terrain, below actors and furniture",
        "risk": "Flower colors must stay readable over Round170 flower/grass props."
    },
    {
        "slug": "orange_tree_small_node",
        "category": "world_resource_node",
        "prompt": "single transparent cozy town resource node prop: a small rounded orange fruit tree, squat trunk, soft leafy crown, a few oranges visible, Animal Crossing-like soft 3/4 game prop style, child-friendly, centered with generous padding, no readable text, no letters, no numbers, no UI card, no full scene, no characters, no reward symbol, flat solid #ff00ff chroma key background only, no cast shadow on background",
        "key_hint": [255, 0, 255],
        "pivot": [96, 172],
        "footprint": "1x1 tile trunk collision, canopy may visually overhang neighboring cells",
        "layer": "small tree resource above ground props, depth-sort by trunk/base pivot",
        "risk": "Canopy overhang needs collision kept to trunk only."
    },
    {
        "slug": "seed_sprout_node",
        "category": "world_resource_node",
        "prompt": "single transparent cozy town resource node prop: a tiny seed sprout emerging from a soft mound of soil with two rounded leaves, Animal Crossing-like soft 3/4 game prop style, child-friendly, centered with generous padding, no readable text, no letters, no numbers, no UI card, no full scene, no characters, no reward symbol, flat solid #ff00ff chroma key background only, no cast shadow on background",
        "key_hint": [255, 0, 255],
        "pivot": [96, 168],
        "footprint": "1x1 tile, very low non-blocking gather/care marker",
        "layer": "ground resource prop above terrain/path, below actors",
        "risk": "Very small leaf shape may need scale-up in runtime proof."
    },
    {
        "slug": "fabric_scrap_basket_node",
        "category": "world_resource_node",
        "prompt": "single transparent cozy town resource node prop: a tiny woven basket holding soft folded fabric scraps, rounded simple cloth shapes, Animal Crossing-like soft 3/4 game prop style, child-friendly, centered with generous padding, no readable text, no letters, no numbers, no patterns that look like letters, no UI card, no full scene, no characters, no reward symbol, flat solid #00ff00 chroma key background only, no cast shadow on background",
        "key_hint": [0, 255, 0],
        "pivot": [96, 168],
        "footprint": "1x1 tile, small low basket collision",
        "layer": "small resource prop above ground, below actors when actor y is in front",
        "risk": "Fabric folds must be checked for accidental text-like marks."
    },
    {
        "slug": "tiny_book_stack_node",
        "category": "world_resource_node",
        "prompt": "single transparent cozy town resource node prop: a tiny stack of blank picture books with rounded covers and no markings, Animal Crossing-like soft 3/4 game prop style, child-friendly, centered with generous padding, absolutely no readable text, no letters, no numbers, no symbols, no UI card, no full scene, no characters, no reward symbol, flat solid #00ff00 chroma key background only, no cast shadow on background",
        "key_hint": [0, 255, 0],
        "pivot": [96, 168],
        "footprint": "1x1 tile, low collectible stack",
        "layer": "ground resource prop above terrain/interior floor, below actors",
        "risk": "Book covers must remain blank before any runtime use."
    },
    {
        "slug": "snack_basket_node",
        "category": "world_resource_node",
        "prompt": "single transparent cozy town resource node prop: a small picnic snack basket with simple round buns and fruit shapes, Animal Crossing-like soft 3/4 game prop style, child-friendly, centered with generous padding, no readable text, no letters, no numbers, no brand labels, no UI card, no full scene, no characters, no reward symbol, flat solid #00ff00 chroma key background only, no cast shadow on background",
        "key_hint": [0, 255, 0],
        "pivot": [96, 168],
        "footprint": "1x1 tile, small basket collision",
        "layer": "small resource prop above ground, below actors when actor y is in front",
        "risk": "Food shapes should stay generic and not read as branded snacks."
    },
    {
        "slug": "coin_sparkle_node",
        "category": "world_resource_node",
        "prompt": "single transparent cozy town resource node prop: a tiny gentle coin glint resource marker, two or three soft round coins with very subtle small sparkles, Animal Crossing-like soft 3/4 game prop style, child-friendly, centered with generous padding, no readable text, no letters, no numbers, no currency marks, no pressure or reward symbols beyond gentle sparkles, no UI card, no full scene, no characters, flat solid #00ff00 chroma key background only, no cast shadow on background",
        "key_hint": [0, 255, 0],
        "pivot": [96, 168],
        "footprint": "1x1 tile, non-blocking tiny collect marker",
        "layer": "ground resource sparkle above terrain/path and below UI feedback",
        "risk": "Sparkles must remain gentle, not reward-pressure effects."
    },
    {
        "slug": "watering_can_pickup_node",
        "category": "world_resource_node",
        "prompt": "single transparent cozy town resource node prop: a small rounded watering can pickup, pastel metal body with simple handle and spout, Animal Crossing-like soft 3/4 game prop style, child-friendly, centered with generous padding, no readable text, no letters, no numbers, no symbols, no UI card, no full scene, no characters, no reward symbol, flat solid #ff00ff chroma key background only, no cast shadow on background",
        "key_hint": [255, 0, 255],
        "pivot": [96, 168],
        "footprint": "1x1 tile, small tool pickup collision",
        "layer": "small resource/tool prop above ground, below actors when actor y is in front",
        "risk": "Spout silhouette is thin; check at mobile scale."
    },
]


def rel(path):
    return str(path.relative_to(ROOT))


def load_font(size):
    for path in (
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        "/usr/share/fonts/truetype/liberation2/LiberationSans-Regular.ttf",
    ):
        if Path(path).exists():
            return ImageFont.truetype(path, size)
    return ImageFont.load_default()


def color_distance(c, k):
    return math.sqrt(sum((int(c[i]) - int(k[i])) ** 2 for i in range(3)))


def estimate_key_color(img, hint):
    rgb = img.convert("RGB")
    w, h = rgb.size
    samples = []
    for x in range(w):
        samples.append(rgb.getpixel((x, 0)))
        samples.append(rgb.getpixel((x, h - 1)))
    for y in range(h):
        samples.append(rgb.getpixel((0, y)))
        samples.append(rgb.getpixel((w - 1, y)))
    best = min(samples, key=lambda c: color_distance(c, hint))
    if color_distance(best, hint) <= 96:
        return best
    buckets = {}
    for c in samples:
        key = tuple(v // 8 * 8 for v in c)
        buckets[key] = buckets.get(key, 0) + 1
    return max(buckets, key=buckets.get)


def has_real_alpha(img):
    if img.mode != "RGBA":
        return False
    alpha = img.getchannel("A")
    extrema = alpha.getextrema()
    corner = alpha.crop((0, 0, min(24, img.width), min(24, img.height))).getextrema()
    return extrema[0] <= 8 and extrema[1] >= 128 and corner[1] <= 16


def source_to_rgba(path, hint):
    raw = Image.open(path).convert("RGBA")
    if has_real_alpha(raw):
        return raw, "generator_rgba_alpha_preserved", None
    key = estimate_key_color(raw, hint)
    out = Image.new("RGBA", raw.size, (0, 0, 0, 0))
    src = raw.load()
    dst = out.load()
    w, h = raw.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = src[x, y]
            magenta_key = key[0] > 140 and key[2] > 110 and key[1] < 130
            magenta_shadow = r > 75 and b > 75 and g < 125 and (r + b - 2 * g) > 65
            if magenta_key and magenta_shadow:
                continue
            d = color_distance((r, g, b), key)
            if d <= 34:
                na = 0
            elif d >= 130:
                na = a
            else:
                na = int(a * ((d - 34) / 96.0))
            if na <= 6:
                continue
            if key[1] > 190 and key[0] < 96:
                g = min(g, int((r + b) / 2 + 24))
            if key[0] > 190 and key[2] > 190:
                r = min(r, int((g + b) / 2 + 30))
                b = min(b, int((r + g) / 2 + 30))
            dst[x, y] = (r, g, b, na)
    return out, "generator_rgb_or_opaque_source_chroma_key_local_rgba", key


def normalize(img):
    alpha = img.getchannel("A")
    bbox = alpha.getbbox()
    if bbox is None:
        return Image.new("RGBA", CANVAS, (0, 0, 0, 0))
    crop = img.crop(bbox)
    max_w = 156
    max_h = 150
    scale = min(max_w / crop.width, max_h / crop.height, 1.0)
    size = (max(1, int(crop.width * scale)), max(1, int(crop.height * scale)))
    crop = crop.resize(size, Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", CANVAS, (0, 0, 0, 0))
    x = (CANVAS[0] - size[0]) // 2
    y = CANVAS[1] - size[1] - 20
    if y < 14:
        y = (CANVAS[1] - size[1]) // 2
    canvas.alpha_composite(crop, (x, y))
    # Generated raws often include soft chroma-tinted "shadows" that are not
    # real object pixels. A firmer cutoff keeps the candidate as a clean cutout.
    alpha = canvas.getchannel("A").point(lambda a: 0 if a < 150 else min(255, int((a - 126) * 255 / 129)))
    canvas.putalpha(alpha)
    return canvas


def audit(path, key_hint):
    img = Image.open(path).convert("RGBA")
    w, h = img.size
    alpha = img.getchannel("A")
    corners = [
        alpha.crop((0, 0, 16, 16)).getextrema()[1],
        alpha.crop((w - 16, 0, w, 16)).getextrema()[1],
        alpha.crop((0, h - 16, 16, h)).getextrema()[1],
        alpha.crop((w - 16, h - 16, w, h)).getextrema()[1],
    ]
    edge_alpha = 0
    visible = 0
    suspicious_key = 0
    low_alpha_chroma_shadow = 0
    semi = 0
    opaque_bbox = alpha.point(lambda a: 255 if a > 12 else 0).getbbox()
    pix = img.load()
    for y in range(h):
        for x in range(w):
            r, g, b, a = pix[x, y]
            if a > 12:
                visible += 1
                if x < 3 or y < 3 or x >= w - 3 or y >= h - 3:
                    edge_alpha += 1
                if color_distance((r, g, b), key_hint) < 72:
                    suspicious_key += 1
                if a < 96:
                    magenta_shadow = r > 90 and b > 90 and g < 130 and (r + b - 2 * g) > 70
                    green_shadow = g > 110 and r < 150 and b < 150 and (2 * g - r - b) > 70
                    if magenta_shadow or green_shadow:
                        low_alpha_chroma_shadow += 1
            if 12 < a < 235:
                semi += 1
    coverage = round(visible / float(w * h), 4)
    bbox_area = 0
    if opaque_bbox:
        bbox_area = (opaque_bbox[2] - opaque_bbox[0]) * (opaque_bbox[3] - opaque_bbox[1])
    background_block = coverage > 0.78 or edge_alpha > 0 or max(corners) > 4
    return {
        "dimensions": [w, h],
        "mode": "RGBA",
        "alpha_extrema": list(alpha.getextrema()),
        "visible_pixel_count": visible,
        "visible_coverage_ratio": coverage,
        "semi_transparent_pixel_count": semi,
        "transparent_corner_alpha_max": max(corners),
        "visible_edge_residue_pixel_count": edge_alpha,
        "suspicious_key_residue_pixel_count": suspicious_key,
        "low_alpha_chroma_shadow_pixel_count": low_alpha_chroma_shadow,
        "background_block_check": "pass" if not background_block and bbox_area > 200 else "fail",
        "pass": (
            (w, h) == CANVAS
            and alpha.getextrema()[0] == 0
            and alpha.getextrema()[1] >= 128
            and max(corners) <= 4
            and edge_alpha == 0
            and suspicious_key <= 6
            and not background_block
            and visible > 200
        ),
    }


def make_atlas(paths):
    cols = 5
    rows = 2
    atlas = Image.new("RGBA", (cols * CANVAS[0], rows * CANVAS[1]), (0, 0, 0, 0))
    for idx, path in enumerate(paths):
        img = Image.open(path).convert("RGBA")
        atlas.alpha_composite(img, ((idx % cols) * CANVAS[0], (idx // cols) * CANVAS[1]))
    atlas_path = ROOT / "round177_world_resource_nodes_atlas_5x2_192.png"
    atlas.save(atlas_path)
    return atlas_path


def make_proof(paths):
    cols = 5
    rows = 2
    cell = 224
    proof = Image.new("RGBA", (cols * cell, rows * cell), (238, 232, 210, 255))
    d = ImageDraw.Draw(proof, "RGBA")
    font = load_font(12)
    for idx, path in enumerate(paths):
        ox = (idx % cols) * cell
        oy = (idx // cols) * cell
        d.rectangle((ox, oy, ox + cell, oy + cell), fill=(214, 232, 196, 255) if idx % 2 == 0 else (226, 214, 190, 255))
        for gx in range(ox, ox + cell, 32):
            d.line((gx, oy, gx, oy + cell), fill=(255, 255, 255, 38), width=1)
        for gy in range(oy, oy + cell, 32):
            d.line((ox, gy, ox + cell, gy), fill=(255, 255, 255, 38), width=1)
        img = Image.open(path).convert("RGBA")
        proof.alpha_composite(img, (ox + 16, oy + 10))
        slug = Path(path).stem.replace("_node", "")
        d.text((ox + 8, oy + cell - 22), slug[:26], fill=(65, 64, 56, 220), font=font)
    proof_path = PROOF / "round177_world_resource_nodes_checker_proof_1120x448.png"
    proof.convert("RGB").save(proof_path)
    return proof_path


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    PROOF.mkdir(parents=True, exist_ok=True)
    commands = []
    normalized_paths = []
    manifest_items = []
    for item in ITEMS:
        raw_path = RAW / f"{item['slug']}_raw.png"
        out_path = OUT / f"{item['slug']}_192x192.png"
        if not raw_path.exists():
            raise FileNotFoundError(f"Missing raw generator output: {raw_path}")
        rgba, method, detected_key = source_to_rgba(raw_path, tuple(item["key_hint"]))
        norm = normalize(rgba)
        norm.save(out_path)
        audit_result = audit(out_path, tuple(item["key_hint"]))
        normalized_paths.append(out_path)
        commands.append(
            f"node /home/xionglei/GameProject/tools/image_generator.js text \"{item['prompt']}\" \"{rel(raw_path)}\" 1024x1024"
        )
        manifest_items.append({
            "id": f"world_resource_nodes.{item['slug']}",
            "slug": item["slug"],
            "status": "pass" if audit_result["pass"] else "fail",
            "category": item["category"],
            "main_ref": rel(out_path),
            "source_ref": rel(raw_path),
            "dimensions": audit_result["dimensions"],
            "pivot_recommendation_px": item["pivot"],
            "footprint_recommendation": item["footprint"],
            "layer_recommendation": item["layer"],
            "prompt": item["prompt"],
            "normalization_method": method,
            "detected_key_color": list(detected_key) if detected_key else None,
            "checks": audit_result,
            "risks": [item["risk"], "Proof-only candidate; no runtime, data, ThemeProfile, or AssetResolver mapping."]
        })
    atlas = make_atlas(normalized_paths)
    proof = make_proof(normalized_paths)
    pass_count = sum(1 for i in manifest_items if i["status"] == "pass")
    fail_count = len(manifest_items) - pass_count
    manifest = {
        "round": 177,
        "pack": "world_resource_nodes",
        "category": "proof_only_world_resource_node_candidates",
        "overall_gate": "pass" if fail_count == 0 else "fail",
        "runtime_boundary": {
            "proof_only": True,
            "runtime_mapping": "none",
            "asset_resolver_mapping": "none",
            "theme_profile_mapping": "none",
            "data_mapping": "none"
        },
        "style_compatibility_notes": [
            "Animal Crossing-like soft 3/4 prop/resource-node candidates.",
            "Designed to sit near Round172 props and Round173 item icons without UI card framing.",
            "No readable text, letters, numbers, pressure/reward symbols, full scenes, or characters requested."
        ],
        "normalization": {
            "canvas_px": list(CANVAS),
            "format": "PNG RGBA",
            "lesson_022_alpha_policy": "Generator output was treated as untrusted; actual alpha was checked and local chroma normalization was used when needed."
        },
        "checks_required": [
            "dimensions",
            "RGBA alpha channel",
            "transparent corners",
            "visible edge residue",
            "suspicious chroma/key residue",
            "background block"
        ],
        "counts": {
            "items_total": len(manifest_items),
            "items_pass": pass_count,
            "items_fail": fail_count
        },
        "atlas_ref": rel(atlas),
        "proof_ref": rel(proof),
        "items": manifest_items,
        "commands": commands,
        "risks": [
            "All files are proof-only and still require art-direction review before any runtime mapping.",
            "Small silhouettes should be checked in the 1280 gameplay target context for contrast and scale.",
            "Coin sparkles are intentionally gentle but should be reviewed against reward-pressure UX rules."
        ]
    }
    manifest_path = ROOT / "manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    print(json.dumps({
        "manifest": rel(manifest_path),
        "overall_gate": manifest["overall_gate"],
        "pass": pass_count,
        "fail": fail_count,
        "atlas": rel(atlas),
        "proof": rel(proof)
    }, indent=2))


if __name__ == "__main__":
    main()
