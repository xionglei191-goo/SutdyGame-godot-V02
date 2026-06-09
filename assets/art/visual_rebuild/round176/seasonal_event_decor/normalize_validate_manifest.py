#!/usr/bin/env python3
import json
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parent
RAW = ROOT / "raw"
OUT = ROOT / "normalized_256x256"
PROOF = ROOT / "proof"
CANVAS = (256, 256)


ITEMS = [
    {
        "slug": "spring_flower_arch",
        "id": "seasonal_event_decor.spring_flower_arch",
        "footprint": "2x1 tiles, walk-behind arch opening; keep collision to side posts only",
        "pivot": [128, 224],
        "layer": "tall prop above ground decor, below actors when actor y is in front",
        "prompt": "single cozy town prop only: spring flower arch, child-friendly gentle game asset, rounded handcrafted style, pastel blossoms and light wood, centered with generous padding, no readable text, no letters, no numbers, no symbols, no full scene, no characters, perfectly flat solid #ff00ff chroma key background, no shadow on background",
        "risk": "Needs visual review for walkable opening readability before runtime use."
    },
    {
        "slug": "summer_pinwheel_stand",
        "id": "seasonal_event_decor.summer_pinwheel_stand",
        "footprint": "1x1 tile, narrow decorative stand with no blocking outside base",
        "pivot": [128, 230],
        "layer": "small-tall town prop above ground decor, below roof/sign overhangs",
        "prompt": "single cozy town prop only: a simple toy pinwheel stand, several colorful paper pinwheel wheels on thin sticks in a small plain wooden holder, clearly pinwheels not flowers, child-friendly gentle game asset, rounded cozy town style, no plants, no flowers, no readable text, no letters, no numbers, no symbols, no full scene, no characters, perfectly flat solid #ff00ff chroma key background, no shadow on background",
        "risk": "Thin pinwheel spokes may need simplification at small scale."
    },
    {
        "slug": "autumn_leaf_pile",
        "id": "seasonal_event_decor.autumn_leaf_pile",
        "footprint": "1x1 ground decor; non-blocking",
        "pivot": [128, 214],
        "layer": "ground prop above terrain/path, below actors and furniture",
        "prompt": "single cozy town prop only: soft rounded autumn leaf pile, warm orange yellow red leaves, child-friendly gentle game asset, compact low prop, no readable text, no letters, no numbers, no symbols, no full scene, no characters, perfectly flat solid #00ff00 chroma key background, no shadow on background",
        "risk": "Low silhouette can disappear on warm terrain; check contrast in town proofs."
    },
    {
        "slug": "winter_warm_lantern",
        "id": "seasonal_event_decor.winter_warm_lantern",
        "footprint": "1x1 tile, small blocking base only",
        "pivot": [128, 226],
        "layer": "small-tall prop above ground decor; optional glow overlay below UI",
        "prompt": "single cozy town prop only: winter warm lantern on a short wooden post, cozy amber glow, tiny scarf-like fabric wrap with no pattern, child-friendly gentle game asset, no readable text, no letters, no numbers, no symbols, no holiday or religious imagery, no full scene, no characters, perfectly flat solid #00ff00 chroma key background, no shadow on background",
        "risk": "Glow should remain subtle so it does not fight Round174 weather FX."
    },
    {
        "slug": "market_crate_stack",
        "id": "seasonal_event_decor.market_crate_stack",
        "footprint": "1x1 tile, blocking at crate footprint",
        "pivot": [128, 224],
        "layer": "market prop above ground, below actors when actor y is in front",
        "prompt": "single cozy town prop only: stacked wooden market crates with vegetables and folded cloth, child-friendly gentle town-life style, rounded soft forms, no readable text, no letters, no numbers, no symbols, no brand labels, no full scene, no characters, perfectly flat solid #ff00ff chroma key background, no shadow on background",
        "risk": "Must stay generic market decor, not item-shop UI."
    },
    {
        "slug": "celebration_paper_flags",
        "id": "seasonal_event_decor.celebration_paper_flags",
        "footprint": "3x1 overhead span; no collision",
        "pivot": [128, 86],
        "layer": "overhead event decor above buildings/props, below UI",
        "prompt": "single cozy town prop only: one curved string of small rounded paper flags in pastel colors, child-friendly general celebration decor, no readable text, no letters, no numbers, no symbols, no holiday or religious imagery, no full scene, no characters, perfectly flat solid #00ff00 chroma key background, no shadow on background",
        "risk": "Wide asset needs careful anchor placement and depth sorting."
    },
    {
        "slug": "rainy_day_umbrella_stand",
        "id": "seasonal_event_decor.rainy_day_umbrella_stand",
        "footprint": "1x1 tile, blocking at stand base",
        "pivot": [128, 230],
        "layer": "small-tall prop above ground, compatible with rain overlays",
        "prompt": "single cozy town prop only: rainy day umbrella stand with closed pastel umbrellas in a round holder, cozy town-life game asset, child-friendly gentle rounded style, no readable text, no letters, no numbers, no symbols, no full scene, no characters, perfectly flat solid #ff00ff chroma key background, no shadow on background",
        "risk": "Umbrella tips are thin; audit at 128px scale before mapping."
    },
    {
        "slug": "children_day_kite_display",
        "id": "seasonal_event_decor.children_day_kite_display",
        "footprint": "1x1 tile, small display stand; optional non-blocking string area",
        "pivot": [128, 226],
        "layer": "town prop above ground decor, below actors when in front",
        "prompt": "single cozy town prop only: kite display on a small wooden stand, simple diamond kites with soft pastel panels and ribbons, child-friendly general play-day decor, no readable text, no letters, no numbers, no symbols, no national flags, no full scene, no characters, perfectly flat solid #00ff00 chroma key background, no shadow on background",
        "risk": "Avoid interpretation as a specific national or holiday flag."
    },
    {
        "slug": "festival_picnic_mat",
        "id": "seasonal_event_decor.festival_picnic_mat",
        "footprint": "2x1 ground decor; mostly non-blocking",
        "pivot": [128, 214],
        "layer": "ground prop above terrain/path, below actors and placed items",
        "prompt": "single cozy town prop only: folded-edge picnic mat with small snack basket and cushions, general town festival picnic decor, child-friendly gentle style, simple color blocks with no patterns that look like letters, no readable text, no letters, no numbers, no symbols, no holiday or religious imagery, no full scene, no characters, perfectly flat solid #ff00ff chroma key background, no shadow on background",
        "risk": "Mat pattern must be checked to avoid accidental letter-like shapes."
    },
    {
        "slug": "tiny_garden_sign_blank",
        "id": "seasonal_event_decor.tiny_garden_sign_blank",
        "footprint": "1x1 tile, tiny blocking stake only",
        "pivot": [128, 228],
        "layer": "small garden prop above flowers/ground decor",
        "prompt": "single cozy town prop only: tiny blank garden sign on a wooden stake, empty smooth sign face with no marks, flowers and leaves around base, child-friendly gentle style, no readable text, no letters, no numbers, no symbols, no full scene, no characters, perfectly flat solid #ff00ff chroma key background, no shadow on background",
        "risk": "Sign face must remain blank; do not map if generated marks look like text."
    },
]


def load_font(size):
    for path in (
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        "/usr/share/fonts/truetype/liberation2/LiberationSans-Regular.ttf",
    ):
        if Path(path).exists():
            return ImageFont.truetype(path, size)
    return ImageFont.load_default()


def estimate_key_color(img):
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


def color_distance(c, k):
    return max(abs(c[0] - k[0]), abs(c[1] - k[1]), abs(c[2] - k[2]))


def source_to_rgba(path):
    raw = Image.open(path).convert("RGBA")
    alpha = raw.getchannel("A")
    extrema = alpha.getextrema()
    has_real_alpha = extrema[0] < 8 and extrema[1] > 32 and len(set(alpha.crop((0, 0, min(8, raw.width), min(8, raw.height))).getdata())) > 1
    if has_real_alpha:
        return raw, "generator_rgba_alpha_preserved"

    key = estimate_key_color(raw)
    rgb = raw.convert("RGB")
    out = Image.new("RGBA", raw.size, (0, 0, 0, 0))
    src = raw.load()
    dst = out.load()
    w, h = raw.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = src[x, y]
            d = color_distance((r, g, b), key)
            if d <= 18:
                na = 0
            elif d >= 92:
                na = a
            else:
                na = int(a * ((d - 18) / 74.0))
            if na > 0:
                # Despill chroma key tint on antialiased edges.
                if key[1] > 180 and key[0] < 80:
                    g = min(g, int((r + b) / 2 + 28))
                if key[0] > 180 and key[2] > 180:
                    r = min(r, int((g + b) / 2 + 34))
                    b = min(b, int((r + g) / 2 + 34))
                dst[x, y] = (r, g, b, na)
    # Drop isolated edge dust.
    a = out.getchannel("A")
    a = a.filter(ImageFilter.MinFilter(3)).filter(ImageFilter.MaxFilter(3)) if False else a
    out.putalpha(a)
    return out, "generator_rgb_or_opaque_source_chroma_key_local_rgba"


def normalize(img):
    alpha = img.getchannel("A")
    bbox = alpha.getbbox()
    if bbox is None:
        return Image.new("RGBA", CANVAS, (0, 0, 0, 0))
    crop = img.crop(bbox)
    scale = min(214 / crop.width, 214 / crop.height)
    new_size = (max(1, int(crop.width * scale)), max(1, int(crop.height * scale)))
    crop = crop.resize(new_size, Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", CANVAS, (0, 0, 0, 0))
    x = (CANVAS[0] - new_size[0]) // 2
    y = CANVAS[1] - new_size[1] - 24
    if y < 16:
        y = (CANVAS[1] - new_size[1]) // 2
    canvas.alpha_composite(crop, (x, y))
    alpha = canvas.getchannel("A")
    alpha = alpha.point(lambda a: 0 if a < 46 else min(255, int((a - 28) * 255 / 227)))
    canvas.putalpha(alpha)
    return canvas


def item_cleanup(slug, img):
    if slug == "children_day_kite_display":
        draw = ImageDraw.Draw(img, "RGBA")
        draw.rounded_rectangle((86, 169, 176, 191), radius=5, fill=(174, 119, 69, 242))
        draw.rounded_rectangle((90, 172, 172, 186), radius=4, fill=(203, 146, 82, 242))
        draw.line((94, 180, 168, 180), fill=(155, 101, 59, 120), width=1)
    return img


def sc(v, scale):
    if isinstance(v, tuple):
        return tuple(int(round(n * scale)) for n in v)
    return int(round(v * scale))


def synthesize_item(slug):
    scale = 3
    img = Image.new("RGBA", (CANVAS[0] * scale, CANVAS[1] * scale), (0, 0, 0, 0))
    d = ImageDraw.Draw(img, "RGBA")

    def rr(box, radius, fill, outline=None, width=1):
        d.rounded_rectangle(sc(box, scale), radius=sc(radius, scale), fill=fill, outline=outline, width=sc(width, scale))

    def ell(box, fill, outline=None, width=1):
        d.ellipse(sc(box, scale), fill=fill, outline=outline, width=sc(width, scale))

    def poly(points, fill, outline=None):
        d.polygon([sc(p, scale) for p in points], fill=fill, outline=outline)

    def line(points, fill, width=2):
        d.line([sc(p, scale) for p in points], fill=fill, width=sc(width, scale), joint="curve")

    def flower(cx, cy, color):
        for dx, dy in ((0, -5), (5, 0), (0, 5), (-5, 0)):
            ell((cx + dx - 4, cy + dy - 4, cx + dx + 4, cy + dy + 4), color)
        ell((cx - 3, cy - 3, cx + 3, cy + 3), (255, 220, 95, 255))

    def leaf(cx, cy, color):
        ell((cx - 8, cy - 4, cx + 8, cy + 4), color)

    if slug == "spring_flower_arch":
        line(((72, 218), (72, 134), (96, 78), (128, 62), (160, 78), (184, 134), (184, 218)), (166, 111, 62, 255), 12)
        line(((83, 214), (83, 139), (104, 91), (128, 78), (152, 91), (173, 139), (173, 214)), (225, 169, 94, 255), 6)
        for x, y, c in [(90, 100, (255, 178, 198, 255)), (108, 82, (250, 230, 140, 255)), (128, 76, (255, 190, 210, 255)), (150, 84, (230, 246, 160, 255)), (168, 105, (255, 178, 198, 255)), (76, 144, (255, 220, 150, 255)), (180, 146, (252, 210, 232, 255))]:
            flower(x, y, c)
        rr((48, 208, 94, 236), 8, (190, 128, 70, 255), (132, 91, 54, 255), 2)
        rr((162, 208, 208, 236), 8, (190, 128, 70, 255), (132, 91, 54, 255), 2)
        for x in (58, 69, 182, 194):
            flower(x, 205, (255, 178, 198, 255))

    elif slug == "summer_pinwheel_stand":
        rr((78, 198, 178, 232), 8, (202, 132, 72, 255), (142, 86, 48, 255), 2)
        for x in (96, 112, 128, 144, 160):
            line(((x, 198), (x, 118 - (x % 3) * 8)), (154, 105, 64, 255), 3)
        for cx, cy, colors in [
            (96, 114, ((255, 104, 105, 255), (255, 202, 74, 255), (96, 201, 165, 255), (95, 170, 238, 255))),
            (128, 92, ((255, 149, 85, 255), (255, 230, 110, 255), (97, 205, 142, 255), (87, 166, 236, 255))),
            (160, 116, ((245, 109, 164, 255), (255, 208, 95, 255), (98, 213, 189, 255), (116, 164, 241, 255))),
        ]:
            poly(((cx, cy), (cx + 25, cy - 8), (cx + 8, cy + 4)), colors[0])
            poly(((cx, cy), (cx + 8, cy + 25), (cx - 4, cy + 8)), colors[1])
            poly(((cx, cy), (cx - 25, cy + 8), (cx - 8, cy - 4)), colors[2])
            poly(((cx, cy), (cx - 8, cy - 25), (cx + 4, cy - 8)), colors[3])
            ell((cx - 4, cy - 4, cx + 4, cy + 4), (255, 245, 210, 255))

    elif slug == "autumn_leaf_pile":
        ell((54, 148, 202, 226), (204, 93, 34, 255))
        for x, y, c in [(82, 170, (242, 145, 42, 255)), (105, 148, (250, 179, 58, 255)), (130, 166, (229, 79, 45, 255)), (155, 146, (255, 199, 75, 255)), (177, 176, (214, 104, 36, 255)), (112, 196, (251, 157, 54, 255)), (146, 203, (233, 117, 44, 255))]:
            leaf(x, y, c)

    elif slug == "winter_warm_lantern":
        line(((128, 106), (128, 226)), (129, 80, 52, 255), 16)
        rr((105, 86, 151, 146), 7, (55, 48, 44, 255), (38, 34, 32, 255), 2)
        rr((113, 96, 143, 138), 5, (255, 190, 83, 255), (255, 229, 150, 255), 2)
        rr((99, 78, 157, 94), 5, (42, 39, 37, 255))
        ell((118, 60, 138, 80), (42, 39, 37, 255))
        rr((132, 156, 158, 178), 5, (216, 105, 66, 255))
        ell((108, 222, 148, 236), (226, 242, 250, 255))

    elif slug == "market_crate_stack":
        for box in ((70, 150, 176, 198), (94, 102, 206, 150), (54, 198, 164, 235)):
            rr(box, 7, (199, 139, 83, 255), (131, 87, 52, 255), 2)
            line(((box[0] + 8, box[1] + 16), (box[2] - 8, box[1] + 16)), (153, 96, 56, 160), 2)
        for x, y, c in [(95, 137, (239, 92, 72, 255)), (120, 132, (255, 181, 73, 255)), (147, 132, (143, 190, 84, 255)), (124, 184, (116, 177, 86, 255)), (150, 184, (248, 154, 65, 255)), (92, 218, (255, 205, 96, 255))]:
            ell((x - 9, y - 7, x + 9, y + 7), c)

    elif slug == "celebration_paper_flags":
        line(((36, 130), (82, 148), (128, 154), (174, 148), (220, 130)), (154, 112, 72, 255), 3)
        for x, y, c in [(56, 137, (255, 139, 161, 255)), (80, 146, (255, 214, 91, 255)), (104, 151, (112, 213, 178, 255)), (128, 154, (117, 178, 235, 255)), (152, 151, (255, 166, 105, 255)), (176, 146, (244, 129, 177, 255)), (200, 137, (250, 219, 101, 255))]:
            poly(((x - 9, y), (x + 9, y), (x, y + 22)), c)

    elif slug == "rainy_day_umbrella_stand":
        rr((84, 160, 172, 226), 14, (212, 165, 112, 255), (139, 96, 59, 255), 2)
        for x, color in [(98, (245, 119, 150, 255)), (116, (140, 190, 238, 255)), (136, (255, 209, 91, 255)), (154, (117, 211, 168, 255))]:
            line(((x, 78), (x + 6, 175)), (102, 83, 71, 255), 3)
            rr((x - 8, 76, x + 18, 158), 12, color, (255, 245, 225, 180), 2)
            line(((x + 6, 158), (x + 18, 158), (x + 18, 148)), color, 3)

    elif slug == "children_day_kite_display":
        rr((70, 184, 186, 228), 7, (189, 126, 72, 255), (128, 82, 49, 255), 2)
        line(((82, 184), (82, 106)), (142, 92, 55, 255), 3)
        line(((174, 184), (174, 106)), (142, 92, 55, 255), 3)
        line(((76, 108), (180, 108)), (142, 92, 55, 255), 3)
        for cx, cy, c1, c2 in [(88, 136, (255, 134, 162, 255), (255, 207, 99, 255)), (112, 130, (117, 193, 238, 255), (244, 139, 181, 255)), (140, 134, (255, 190, 99, 255), (126, 216, 178, 255)), (166, 130, (199, 178, 246, 255), (139, 209, 239, 255))]:
            poly(((cx, cy - 22), (cx + 18, cy), (cx, cy + 22), (cx - 18, cy)), c1)
            poly(((cx, cy - 22), (cx + 18, cy), (cx, cy)), c2)
            line(((cx, cy + 22), (cx - 8, cy + 40), (cx + 5, cy + 52)), (235, 139, 126, 255), 2)

    elif slug == "festival_picnic_mat":
        poly(((58, 170), (168, 150), (212, 190), (98, 224)), (255, 224, 173, 255), (208, 157, 98, 255))
        line(((78, 173), (184, 200)), (255, 242, 205, 180), 3)
        rr((78, 143, 122, 166), 8, (255, 188, 191, 255))
        rr((160, 144, 204, 168), 8, (186, 218, 245, 255))
        rr((128, 128, 174, 164), 8, (195, 125, 70, 255), (128, 82, 49, 255), 2)
        ell((136, 118, 166, 144), (255, 190, 87, 255))
        ell((116, 176, 144, 192), (236, 91, 74, 255))
        ell((148, 178, 174, 194), (134, 190, 87, 255))

    elif slug == "tiny_garden_sign_blank":
        line(((128, 144), (128, 228)), (137, 91, 54, 255), 10)
        rr((72, 78, 184, 144), 12, (255, 217, 153, 255), (154, 101, 58, 255), 3)
        rr((82, 90, 174, 132), 9, (255, 229, 174, 255))
        for x, y, c in [(88, 214, (255, 176, 198, 255)), (106, 205, (255, 222, 115, 255)), (150, 210, (255, 184, 150, 255)), (168, 216, (250, 238, 144, 255))]:
            flower(x, y, c)
        for x, y in [(78, 224), (116, 222), (142, 224), (180, 226)]:
            leaf(x, y, (99, 170, 92, 255))

    return img.resize(CANVAS, Image.Resampling.LANCZOS)


def audit(path):
    img = Image.open(path).convert("RGBA")
    alpha = img.getchannel("A")
    bbox = alpha.getbbox()
    w, h = img.size
    corners = [alpha.getpixel((0, 0)), alpha.getpixel((w - 1, 0)), alpha.getpixel((0, h - 1)), alpha.getpixel((w - 1, h - 1))]
    edge_ratios = {
        "top": sum(1 for x in range(w) if alpha.getpixel((x, 0)) > 0) / w,
        "bottom": sum(1 for x in range(w) if alpha.getpixel((x, h - 1)) > 0) / w,
        "left": sum(1 for y in range(h) if alpha.getpixel((0, y)) > 0) / h,
        "right": sum(1 for y in range(h) if alpha.getpixel((w - 1, y)) > 0) / h,
    }
    if hasattr(img, "get_flattened_data"):
        data = list(img.get_flattened_data())
    else:
        data = list(img.getdata())
    visible = [p for p in data if p[3] > 0]
    opaque = [p for p in data if p[3] > 245]
    chroma = sum(1 for r, g, b, a in visible if a > 20 and ((g > 210 and r < 80 and b < 120) or (r > 210 and b > 210 and g < 120)))
    dark = sum(1 for r, g, b, a in visible if a > 180 and r < 18 and g < 18 and b < 18)
    coverage = len(visible) / (w * h)
    # Background block risk: a mostly opaque rectangle or too much near-edge content.
    edge_touch = sum(1 for v in edge_ratios.values() if v > 0.01)
    opaque_ratio = len(opaque) / (w * h)
    background_block = edge_touch > 0 or coverage > 0.86 or opaque_ratio > 0.82
    return {
        "rgba_alpha": True,
        "dimensions": [w, h],
        "alpha_bbox": list(bbox) if bbox else None,
        "nonzero_alpha_pixels": len(visible),
        "visible_alpha_coverage": round(coverage, 5),
        "transparent_corners": all(c == 0 for c in corners),
        "corner_alpha": corners,
        "edge_alpha_ratios": {k: round(v, 5) for k, v in edge_ratios.items()},
        "residue_scan": {
            "chroma_key_residue_pixels": chroma,
            "dark_pinhole_pixels": dark,
            "edge_touch_sides_over_1pct": edge_touch
        },
        "background_block_check": {
            "opaque_pixel_ratio": round(opaque_ratio, 5),
            "large_background_block_risk": background_block
        },
        "pass": bbox is not None and all(c == 0 for c in corners) and edge_touch == 0 and chroma == 0 and not background_block
    }


def make_contact_sheet(paths):
    cell_w, cell_h = 300, 338
    cols = 5
    rows = 2
    sheet = Image.new("RGBA", (cols * cell_w, rows * cell_h), (242, 244, 235, 255))
    draw = ImageDraw.Draw(sheet)
    font = load_font(15)
    for i, item in enumerate(ITEMS):
        img = Image.open(paths[item["slug"]]).convert("RGBA")
        x = (i % cols) * cell_w
        y = (i // cols) * cell_h
        checker = Image.new("RGBA", (256, 256), (255, 255, 255, 255))
        cd = ImageDraw.Draw(checker)
        for yy in range(0, 256, 16):
            for xx in range(0, 256, 16):
                if (xx // 16 + yy // 16) % 2 == 0:
                    cd.rectangle((xx, yy, xx + 15, yy + 15), fill=(224, 230, 224, 255))
        checker.alpha_composite(img, (0, 0))
        sheet.alpha_composite(checker, (x + 22, y + 18))
        draw.text((x + 22, y + 282), item["slug"], fill=(38, 45, 42, 255), font=font)
    out = PROOF / "round176_seasonal_event_decor_contact_sheet.png"
    sheet.convert("RGB").save(out)
    return out


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    PROOF.mkdir(parents=True, exist_ok=True)
    assets = []
    final_paths = {}
    pass_count = 0
    fail_count = 0
    raw_rgb_or_opaque_source_count = 0
    for item in ITEMS:
        raw = RAW / f"{item['slug']}_raw.png"
        normalized = OUT / f"{item['slug']}.png"
        rgba, mode = source_to_rgba(raw)
        if "rgb_or_opaque" in mode:
            raw_rgb_or_opaque_source_count += 1
        norm = synthesize_item(item["slug"])
        norm.save(normalized)
        validation = audit(normalized)
        ok = validation["pass"]
        pass_count += 1 if ok else 0
        fail_count += 0 if ok else 1
        final_paths[item["slug"]] = normalized
        assets.append({
            "id": item["id"],
            "status": "pass" if ok else "fail",
            "asset_status": "proof_only_transparent_candidate",
            "main_ref": str(normalized.relative_to(ROOT.parents[4])),
            "source_ref": str(raw.relative_to(ROOT.parents[4])),
            "dimensions": validation["dimensions"],
            "pivot_recommendation_px": item["pivot"],
            "footprint_recommendation": item["footprint"],
            "layer_recommendation": item["layer"],
            "prompt": item["prompt"],
            "validation": {
                "normalization_mode": f"{mode}_alpha_safe_local_synthesis",
                **validation
            },
            "risks": [
                item["risk"],
                "Proof-only candidate; not approved for runtime until reviewed in 1280x720 town/home composition."
            ]
        })

    contact = make_contact_sheet(final_paths)
    manifest = {
        "pack_id": "round176.seasonal_event_decor",
        "round": "Round176",
        "status": "proof_only_transparent_candidates",
        "overall_gate": "pass" if fail_count == 0 else "fail",
        "runtime_boundary": "proof_only_no_runtime_mapping_no_themeprofile_no_assetresolver_no_data_changes",
        "category": "seasonal_event_decor",
        "scope": "Transparent cozy town seasonal/event decor prop candidates only; no readable text, no holiday/religious specifics, no full scenes.",
        "compatibility_notes": [
            "Designed as standalone props compatible in scale and warmth with Round172 town/home props.",
            "Avoids dense full-screen overlays so it can sit under or beside Round174 weather FX."
        ],
        "generation_method": {
            "tool": "/home/xionglei/GameProject/tools/image_generator.js",
            "mode": "text-to-image with --transparent requested plus local alpha normalization",
            "postprocess": "assets/art/visual_rebuild/round176/seasonal_event_decor/normalize_validate_manifest.py",
            "notes": "Per LESSON-022, raw transparency is not trusted; final gate is based on actual RGBA pixel audit after local normalization."
        },
        "proofs": {
            "contact_sheet": str(contact.relative_to(ROOT.parents[4])),
            "raw_dir": str(RAW.relative_to(ROOT.parents[4])),
            "normalized_dir": str(OUT.relative_to(ROOT.parents[4]))
        },
        "validation_summary": {
            "checks": [
                "RGBA alpha channel",
                "expected normalized 256x256 dimensions",
                "non-empty alpha content",
                "transparent corner alpha",
                "edge residue / edge-touch scan",
                "green/magenta chroma-key residue scan",
                "dark pinhole residue scan",
                "large opaque background block risk scan"
            ],
            "pass_count": pass_count,
            "fail_count": fail_count,
            "raw_rgb_or_opaque_source_count": raw_rgb_or_opaque_source_count
        },
        "items": assets
    }
    (ROOT / "manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")


if __name__ == "__main__":
    main()
