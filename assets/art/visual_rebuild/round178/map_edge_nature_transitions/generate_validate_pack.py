#!/usr/bin/env python3
"""Generate proof-only RGBA map-edge / nature transition candidates."""

from __future__ import annotations

import json
import math
from pathlib import Path
from typing import Callable

from PIL import Image, ImageDraw, ImageFilter


ROOT = Path("assets/art/visual_rebuild/round178/map_edge_nature_transitions")
NORMALIZED_DIR = ROOT / "normalized_384x192"
PROOF_DIR = ROOT / "proof"
MANIFEST_PATH = ROOT / "manifest.json"
CONTACT_SHEET = PROOF_DIR / "round178_map_edge_nature_transitions_contact_sheet.png"
SIZE = (384, 192)
SCALE = 3


GREEN = (0, 255, 0)
MAGENTA = (255, 0, 255)


ITEMS = [
    {
        "slug": "meadow_to_path_corner_soft",
        "id": "map_edge_nature_transitions.meadow_to_path_corner_soft",
        "role": "Soft curved meadow/path corner overlay, useful for breaking square path bends near home and plaza routes.",
        "places": ["meadow", "path"],
    },
    {
        "slug": "grass_to_plaza_pebble_edge",
        "id": "map_edge_nature_transitions.grass_to_plaza_pebble_edge",
        "role": "Low grass into pebble plaza edge, intended as a gentle plaza boundary softener.",
        "places": ["grass", "plaza"],
    },
    {
        "slug": "garden_bush_depth_cluster",
        "id": "map_edge_nature_transitions.garden_bush_depth_cluster",
        "role": "Layerable bush-depth cluster for meadow, shop, and home yard edges.",
        "places": ["garden", "home", "shop"],
    },
    {
        "slug": "tiny_flower_depth_strip",
        "id": "map_edge_nature_transitions.tiny_flower_depth_strip",
        "role": "Tiny flower strip that adds depth along meadow/path boundaries without becoming a full flowerbed tile.",
        "places": ["meadow", "path", "plaza"],
    },
    {
        "slug": "pond_grass_reed_corner",
        "id": "map_edge_nature_transitions.pond_grass_reed_corner",
        "role": "Rounded pond bank corner with reeds and soft grass for water-to-meadow transitions.",
        "places": ["water", "meadow"],
    },
    {
        "slug": "home_yard_shadow_patch",
        "id": "map_edge_nature_transitions.home_yard_shadow_patch",
        "role": "Warm translucent yard shadow patch for the base of home prefabs, fences, or porch edges.",
        "places": ["home", "yard"],
    },
    {
        "slug": "school_yard_chalkless_edge",
        "id": "map_edge_nature_transitions.school_yard_chalkless_edge",
        "role": "Soft school-yard edge with grass, pebbles, and clean playfield color; no chalk marks or text.",
        "places": ["school", "yard", "grass"],
    },
    {
        "slug": "shop_front_planter_edge",
        "id": "map_edge_nature_transitions.shop_front_planter_edge",
        "role": "Low planter-front transition for shop thresholds and plaza approach edges.",
        "places": ["shop", "plaza", "grass"],
    },
    {
        "slug": "tree_shadow_ground_soft",
        "id": "map_edge_nature_transitions.tree_shadow_ground_soft",
        "role": "Soft tree-canopy ground shadow with scattered leaf hints for depth under tree clusters.",
        "places": ["meadow", "tree"],
    },
    {
        "slug": "coast_sand_grass_curve",
        "id": "map_edge_nature_transitions.coast_sand_grass_curve",
        "role": "Curved sand-to-grass edge for cozy water/coast boundaries or beach-like town corners.",
        "places": ["coast", "sand", "grass"],
    },
]


def rgba(color: tuple[int, int, int], alpha: int) -> tuple[int, int, int, int]:
    return (color[0], color[1], color[2], alpha)


def make_canvas() -> Image.Image:
    return Image.new("RGBA", (SIZE[0] * SCALE, SIZE[1] * SCALE), (0, 0, 0, 0))


def dxy(points: list[tuple[float, float]]) -> list[tuple[int, int]]:
    return [(round(x * SCALE), round(y * SCALE)) for x, y in points]


def ellipse(draw: ImageDraw.ImageDraw, box: tuple[float, float, float, float], color: tuple[int, int, int, int]) -> None:
    draw.ellipse(tuple(round(v * SCALE) for v in box), fill=color)


def poly(draw: ImageDraw.ImageDraw, points: list[tuple[float, float]], color: tuple[int, int, int, int]) -> None:
    draw.polygon(dxy(points), fill=color)


def line(draw: ImageDraw.ImageDraw, points: list[tuple[float, float]], color: tuple[int, int, int, int], width: float = 1.0) -> None:
    draw.line(dxy(points), fill=color, width=max(1, round(width * SCALE)), joint="curve")


def blur_layer(base: Image.Image, draw_fn: Callable[[ImageDraw.ImageDraw], None], radius: float) -> None:
    layer = make_canvas()
    draw_fn(ImageDraw.Draw(layer))
    base.alpha_composite(layer.filter(ImageFilter.GaussianBlur(radius * SCALE)))


def add_grass_tufts(draw: ImageDraw.ImageDraw, positions: list[tuple[float, float]], color=(87, 151, 89), alpha=185) -> None:
    for x, y in positions:
        line(draw, [(x, y + 8), (x - 4, y - 5)], rgba(color, alpha), 2)
        line(draw, [(x + 2, y + 7), (x + 2, y - 7)], rgba((104, 170, 96), alpha), 2)
        line(draw, [(x + 4, y + 8), (x + 9, y - 3)], rgba(color, alpha), 2)


def add_pebbles(draw: ImageDraw.ImageDraw, positions: list[tuple[float, float]], colors: list[tuple[int, int, int]]) -> None:
    for index, (x, y) in enumerate(positions):
        color = colors[index % len(colors)]
        ellipse(draw, (x - 5, y - 3, x + 5, y + 3), rgba(color, 205))


def add_flowers(draw: ImageDraw.ImageDraw, positions: list[tuple[float, float]], colors: list[tuple[int, int, int]]) -> None:
    for index, (x, y) in enumerate(positions):
        petal = colors[index % len(colors)]
        ellipse(draw, (x - 3, y - 2, x + 3, y + 4), rgba(petal, 220))
        ellipse(draw, (x - 1, y - 4, x + 5, y + 2), rgba(petal, 210))
        ellipse(draw, (x + 1, y, x + 5, y + 5), rgba((252, 220, 107), 230))


def finish(img: Image.Image) -> Image.Image:
    img = img.resize(SIZE, Image.Resampling.LANCZOS)
    pixels = img.load()
    width, height = img.size
    corner_radius = 18
    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            in_corner = (
                (x < corner_radius and y < corner_radius)
                or (x >= width - corner_radius and y < corner_radius)
                or (x < corner_radius and y >= height - corner_radius)
                or (x >= width - corner_radius and y >= height - corner_radius)
            )
            if a <= 3 or in_corner:
                pixels[x, y] = (0, 0, 0, 0)
    return img


def draw_meadow_to_path_corner_soft() -> Image.Image:
    img = make_canvas()
    blur_layer(img, lambda d: ellipse(d, (-20, 12, 410, 226), rgba((142, 194, 112), 74)), 10)
    d = ImageDraw.Draw(img)
    poly(d, [(6, 154), (55, 110), (126, 86), (230, 73), (384, 58), (384, 192), (0, 192)], rgba((207, 177, 121), 210))
    poly(d, [(0, 114), (70, 92), (154, 75), (260, 57), (384, 42), (384, 68), (238, 84), (130, 98), (48, 123), (0, 160)], rgba((123, 183, 99), 215))
    line(d, [(18, 140), (98, 105), (190, 82), (292, 67), (376, 55)], rgba((91, 151, 84), 130), 5)
    add_grass_tufts(d, [(42, 122), (86, 108), (140, 92), (212, 79), (294, 66), (346, 58)])
    add_pebbles(d, [(108, 149), (165, 132), (223, 118), (286, 104), (337, 92)], [(188, 154, 106), (225, 199, 150)])
    return finish(img)


def draw_grass_to_plaza_pebble_edge() -> Image.Image:
    img = make_canvas()
    d = ImageDraw.Draw(img)
    blur_layer(img, lambda b: poly(b, [(0, 82), (120, 68), (255, 78), (384, 64), (384, 134), (0, 148)], rgba((135, 190, 104), 82)), 8)
    poly(d, [(0, 98), (70, 82), (150, 78), (235, 88), (320, 80), (384, 70), (384, 192), (0, 192)], rgba((216, 203, 173), 210))
    poly(d, [(0, 72), (92, 63), (182, 67), (280, 73), (384, 57), (384, 92), (286, 101), (190, 94), (86, 91), (0, 105)], rgba((115, 179, 101), 218))
    add_pebbles(d, [(38, 124), (76, 116), (128, 125), (184, 111), (232, 127), (286, 111), (338, 120)], [(191, 178, 151), (232, 220, 190), (171, 155, 130)])
    add_grass_tufts(d, [(54, 88), (146, 79), (248, 88), (340, 75)])
    return finish(img)


def draw_garden_bush_depth_cluster() -> Image.Image:
    img = make_canvas()
    blur_layer(img, lambda d: ellipse(d, (18, 110, 356, 190), rgba((72, 105, 75), 70)), 7)
    d = ImageDraw.Draw(img)
    for box, color in [
        ((44, 78, 135, 165), (90, 154, 92)),
        ((102, 54, 212, 165), (111, 178, 99)),
        ((184, 68, 306, 170), (83, 145, 90)),
        ((258, 92, 356, 176), (107, 169, 97)),
    ]:
        ellipse(d, box, rgba(color, 230))
    for box in [(80, 92, 146, 154), (158, 78, 224, 146), (238, 100, 314, 166)]:
        ellipse(d, box, rgba((142, 202, 112), 160))
    add_flowers(d, [(116, 105), (190, 92), (274, 117), (306, 135)], [(244, 163, 139), (248, 211, 116)])
    return finish(img)


def draw_tiny_flower_depth_strip() -> Image.Image:
    img = make_canvas()
    d = ImageDraw.Draw(img)
    blur_layer(img, lambda b: poly(b, [(0, 116), (80, 104), (168, 113), (250, 100), (384, 116), (384, 169), (0, 172)], rgba((105, 166, 95), 72)), 6)
    poly(d, [(0, 126), (72, 118), (145, 121), (235, 111), (310, 123), (384, 115), (384, 152), (0, 160)], rgba((100, 164, 94), 190))
    add_grass_tufts(d, [(24, 128), (68, 122), (108, 126), (154, 122), (202, 116), (250, 119), (302, 126), (348, 119)], alpha=170)
    add_flowers(d, [(46, 124), (94, 119), (132, 127), (182, 117), (224, 111), (276, 122), (330, 120), (365, 116)], [(248, 180, 180), (255, 225, 128), (177, 203, 255)])
    return finish(img)


def draw_pond_grass_reed_corner() -> Image.Image:
    img = make_canvas()
    d = ImageDraw.Draw(img)
    blur_layer(img, lambda b: ellipse(b, (-42, 26, 232, 246), rgba((76, 154, 158), 96)), 7)
    ellipse(d, (-34, 36, 216, 234), rgba((92, 168, 174), 198))
    ellipse(d, (8, 66, 190, 204), rgba((126, 196, 191), 105))
    poly(d, [(135, 32), (194, 43), (252, 76), (307, 128), (372, 169), (384, 192), (112, 192), (126, 124)], rgba((113, 178, 98), 220))
    line(d, [(119, 51), (174, 60), (232, 90), (286, 132), (354, 174)], rgba((76, 142, 92), 150), 6)
    for x, y in [(168, 74), (190, 88), (216, 103), (245, 124)]:
        line(d, [(x, y + 24), (x - 4, y - 9)], rgba((86, 137, 72), 210), 3)
        ellipse(d, (x - 8, y - 14, x + 3, y - 3), rgba((168, 133, 86), 220))
    add_grass_tufts(d, [(150, 96), (209, 119), (273, 146), (328, 172)])
    return finish(img)


def draw_home_yard_shadow_patch() -> Image.Image:
    img = make_canvas()
    d = ImageDraw.Draw(img)
    blur_layer(img, lambda b: ellipse(b, (30, 72, 355, 165), rgba((79, 91, 70), 90)), 13)
    blur_layer(img, lambda b: ellipse(b, (75, 90, 305, 156), rgba((88, 102, 77), 60)), 6)
    for x, y in [(78, 126), (132, 118), (246, 118), (310, 130)]:
        ellipse(d, (x - 4, y - 2, x + 4, y + 2), rgba((119, 150, 91), 95))
    return finish(img)


def draw_school_yard_chalkless_edge() -> Image.Image:
    img = make_canvas()
    d = ImageDraw.Draw(img)
    blur_layer(img, lambda b: poly(b, [(0, 82), (84, 82), (176, 92), (282, 82), (384, 88), (384, 158), (0, 152)], rgba((198, 184, 148), 78)), 8)
    poly(d, [(0, 95), (76, 88), (154, 98), (242, 91), (310, 96), (384, 90), (384, 192), (0, 192)], rgba((194, 177, 139), 210))
    poly(d, [(0, 70), (82, 64), (170, 74), (252, 69), (384, 75), (384, 104), (256, 99), (166, 104), (76, 95), (0, 102)], rgba((118, 176, 102), 205))
    add_pebbles(d, [(64, 122), (126, 116), (202, 123), (284, 116), (340, 130)], [(181, 160, 126), (221, 206, 169)])
    add_grass_tufts(d, [(38, 88), (118, 80), (222, 84), (330, 88)], alpha=160)
    return finish(img)


def draw_shop_front_planter_edge() -> Image.Image:
    img = make_canvas()
    d = ImageDraw.Draw(img)
    blur_layer(img, lambda b: ellipse(b, (20, 112, 366, 184), rgba((71, 91, 68), 72)), 5)
    poly(d, [(52, 100), (334, 100), (358, 132), (329, 157), (74, 157), (28, 130)], rgba((174, 132, 92), 230))
    poly(d, [(62, 91), (326, 91), (334, 111), (54, 111)], rgba((207, 166, 116), 235))
    for x in range(78, 322, 36):
        ellipse(d, (x - 26, 68, x + 28, 121), rgba((91, 156, 89), 225))
        ellipse(d, (x - 14, 60, x + 34, 112), rgba((121, 186, 97), 195))
    add_flowers(d, [(93, 82), (146, 75), (205, 82), (262, 76), (305, 84)], [(250, 180, 141), (255, 219, 113), (178, 207, 252)])
    return finish(img)


def draw_tree_shadow_ground_soft() -> Image.Image:
    img = make_canvas()
    d = ImageDraw.Draw(img)
    blur_layer(img, lambda b: ellipse(b, (20, 36, 362, 164), rgba((60, 80, 68), 82)), 18)
    blur_layer(img, lambda b: ellipse(b, (96, 70, 285, 150), rgba((47, 69, 61), 48)), 7)
    for x, y, rot in [(90, 120, 0.5), (154, 95, -0.2), (235, 112, 0.3), (298, 102, -0.5)]:
        pts = [(x - 5, y), (x, y - 4), (x + 9, y - 2), (x + 3, y + 3)]
        poly(d, pts, rgba((126, 171, 86), 105 + int(abs(rot) * 20)))
    return finish(img)


def draw_coast_sand_grass_curve() -> Image.Image:
    img = make_canvas()
    d = ImageDraw.Draw(img)
    blur_layer(img, lambda b: ellipse(b, (18, 46, 416, 222), rgba((229, 205, 147), 78)), 8)
    poly(d, [(0, 118), (62, 94), (142, 78), (232, 88), (304, 114), (384, 126), (384, 192), (0, 192)], rgba((224, 199, 139), 220))
    poly(d, [(0, 74), (74, 65), (152, 58), (248, 72), (326, 91), (384, 98), (384, 134), (304, 122), (226, 96), (142, 88), (58, 102), (0, 126)], rgba((114, 178, 98), 220))
    line(d, [(0, 122), (66, 99), (144, 84), (230, 92), (305, 119), (384, 131)], rgba((183, 159, 105), 120), 4)
    add_grass_tufts(d, [(46, 100), (118, 82), (188, 86), (282, 112), (342, 124)], alpha=170)
    add_pebbles(d, [(92, 133), (166, 118), (250, 131), (318, 147)], [(203, 174, 116), (238, 215, 158)])
    return finish(img)


DRAWERS: dict[str, Callable[[], Image.Image]] = {
    "meadow_to_path_corner_soft": draw_meadow_to_path_corner_soft,
    "grass_to_plaza_pebble_edge": draw_grass_to_plaza_pebble_edge,
    "garden_bush_depth_cluster": draw_garden_bush_depth_cluster,
    "tiny_flower_depth_strip": draw_tiny_flower_depth_strip,
    "pond_grass_reed_corner": draw_pond_grass_reed_corner,
    "home_yard_shadow_patch": draw_home_yard_shadow_patch,
    "school_yard_chalkless_edge": draw_school_yard_chalkless_edge,
    "shop_front_planter_edge": draw_shop_front_planter_edge,
    "tree_shadow_ground_soft": draw_tree_shadow_ground_soft,
    "coast_sand_grass_curve": draw_coast_sand_grass_curve,
}


def audit_image(path: Path) -> dict:
    image = Image.open(path).convert("RGBA")
    width, height = image.size
    if hasattr(image, "get_flattened_data"):
        data = list(image.get_flattened_data())
    else:
        data = list(image.getdata())
    alpha = [px[3] for px in data]
    nonzero = sum(1 for a in alpha if a > 0)
    opaque = sum(1 for a in alpha if a >= 245)
    chroma = 0
    suspicious = 0
    magenta_fringe = 0
    green_fringe = 0
    for r, g, b, a in data:
        if a > 0 and (abs(r - GREEN[0]) + abs(g - GREEN[1]) + abs(b - GREEN[2]) < 35 or abs(r - MAGENTA[0]) + abs(g - MAGENTA[1]) + abs(b - MAGENTA[2]) < 35):
            chroma += 1
        if 0 < a < 180 and r > 170 and b > 145 and g < 120:
            magenta_fringe += 1
        if 0 < a < 180 and g > 230 and r < 80 and b < 80:
            green_fringe += 1
        if 0 < a < 32 and ((g > 220 and r < 100 and b < 100) or (r > 200 and b > 180 and g < 130)):
            suspicious += 1
    corner_alpha = [
        image.getpixel((0, 0))[3],
        image.getpixel((width - 1, 0))[3],
        image.getpixel((0, height - 1))[3],
        image.getpixel((width - 1, height - 1))[3],
    ]
    xs = [i % width for i, a in enumerate(alpha) if a > 0]
    ys = [i // width for i, a in enumerate(alpha) if a > 0]
    bbox = [min(xs), min(ys), max(xs), max(ys)] if xs else None
    edge_alpha_ratios = {
        "top": round(sum(1 for x in range(width) if image.getpixel((x, 0))[3] > 0) / width, 5),
        "bottom": round(sum(1 for x in range(width) if image.getpixel((x, height - 1))[3] > 0) / width, 5),
        "left": round(sum(1 for y in range(height) if image.getpixel((0, y))[3] > 0) / height, 5),
        "right": round(sum(1 for y in range(height) if image.getpixel((width - 1, y))[3] > 0) / height, 5),
    }
    passed = (
        image.mode == "RGBA"
        and (width, height) == SIZE
        and nonzero > 1500
        and all(a == 0 for a in corner_alpha)
        and chroma == 0
        and magenta_fringe == 0
        and green_fringe == 0
        and suspicious == 0
    )
    return {
        "rgba_alpha": image.mode == "RGBA",
        "dimensions": [width, height],
        "alpha_bbox": bbox,
        "nonzero_alpha_pixels": nonzero,
        "visible_alpha_coverage": round(nonzero / (width * height), 5),
        "opaque_pixel_ratio": round(opaque / (width * height), 5),
        "transparent_corners": all(a == 0 for a in corner_alpha),
        "corner_alpha": corner_alpha,
        "edge_alpha_ratios": edge_alpha_ratios,
        "residue_scan": {
            "chroma_key_residue_pixels": chroma,
            "magenta_fringe_pixel_count": magenta_fringe,
            "green_fringe_pixel_count": green_fringe,
            "suspicious_alpha_edge_residue_pixels": suspicious,
        },
        "pass": passed,
    }


def create_contact_sheet(paths: list[Path]) -> None:
    cell_w, cell_h = SIZE
    margin = 28
    cols = 2
    rows = math.ceil(len(paths) / cols)
    sheet = Image.new("RGBA", (cols * cell_w + (cols + 1) * margin, rows * cell_h + (rows + 1) * margin), (236, 236, 226, 255))
    checker = Image.new("RGBA", SIZE, (0, 0, 0, 0))
    cd = ImageDraw.Draw(checker)
    step = 24
    for y in range(0, SIZE[1], step):
        for x in range(0, SIZE[0], step):
            color = (232, 226, 212, 255) if (x // step + y // step) % 2 == 0 else (248, 245, 234, 255)
            cd.rectangle((x, y, x + step - 1, y + step - 1), fill=color)
    for index, path in enumerate(paths):
        x = margin + (index % cols) * (cell_w + margin)
        y = margin + (index // cols) * (cell_h + margin)
        sheet.alpha_composite(checker, (x, y))
        sheet.alpha_composite(Image.open(path).convert("RGBA"), (x, y))
    sheet.save(CONTACT_SHEET)


def main() -> None:
    NORMALIZED_DIR.mkdir(parents=True, exist_ok=True)
    PROOF_DIR.mkdir(parents=True, exist_ok=True)

    manifest_items = []
    output_paths = []
    for item in ITEMS:
        image = DRAWERS[item["slug"]]()
        out_path = NORMALIZED_DIR / f"{item['slug']}.png"
        image.save(out_path)
        output_paths.append(out_path)
        validation = audit_image(out_path)
        manifest_items.append({
            "id": item["id"],
            "slug": item["slug"],
            "status": "pass" if validation["pass"] else "fail",
            "asset_status": "proof_only_transparent_candidate",
            "normalized_png": str(out_path),
            "main_ref": str(out_path),
            "dimensions": list(SIZE),
            "logical_id": item["id"],
            "intended_transition_role": item["role"],
            "place_compatibility": item["places"],
            "pivot_recommendation_px": [SIZE[0] // 2, SIZE[1] - 22],
            "layer_recommendation": "overlay above terrain/path/water base regions, below actors and tall prefabs unless used as a shadow",
            "validation": validation,
            "risks": [
                "Proof-only visual candidate; final art direction review is required before runtime use.",
                "Not tile-certified or collision-certified; no runtime, ThemeProfile, AssetResolver, data, or shared-test mapping.",
            ],
        })

    create_contact_sheet(output_paths)
    fail_count = sum(1 for item in manifest_items if item["status"] != "pass")
    manifest = {
        "pack_id": "round178.map_edge_nature_transitions",
        "round": "Round178",
        "status": "proof_only_transparent_candidates",
        "overall_gate": "pass" if fail_count == 0 else "fail",
        "runtime_boundary": "proof_only_no_runtime_mapping_no_themeprofile_no_assetresolver_no_data_changes",
        "category": "map_edge_nature_transitions",
        "scope": "Proof-only cozy map-edge / nature transition candidates for softening boundaries between meadow, path, home, school, shop, water, and plaza; no full-map background, no hard grid, no text.",
        "generation_method": {
            "tool": "local deterministic Pillow synthesis",
            "mode": "RGBA transparent proof candidates; no fallback generator dependency",
            "postprocess": str(Path(__file__)),
            "notes": "Per LESSON-022, gate is based on actual file alpha. Per LESSON-020, visible key pixels, magenta/green fringe, and suspicious alpha-edge residue are recorded.",
        },
        "proof": str(CONTACT_SHEET),
        "proofs": {
            "contact_sheet": str(CONTACT_SHEET),
            "normalized_dir": str(NORMALIZED_DIR),
        },
        "validation_summary": {
            "checks": [
                "RGBA alpha channel",
                "expected 384x192 dimensions",
                "non-empty alpha content",
                "transparent corners",
                "visible green/magenta chroma-key residue scan",
                "magenta/green fringe scan",
                "suspicious low-alpha edge residue scan",
            ],
            "pass_count": len(manifest_items) - fail_count,
            "fail_count": fail_count,
            "item_count": len(manifest_items),
        },
        "items": manifest_items,
    }
    MANIFEST_PATH.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({
        "manifest": str(MANIFEST_PATH),
        "contact_sheet": str(CONTACT_SHEET),
        "item_count": len(manifest_items),
        "fail_count": fail_count,
    }, ensure_ascii=False, indent=2))
    raise SystemExit(1 if fail_count else 0)


if __name__ == "__main__":
    main()
