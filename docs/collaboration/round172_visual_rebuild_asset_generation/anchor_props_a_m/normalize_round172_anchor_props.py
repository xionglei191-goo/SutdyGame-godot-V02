from __future__ import annotations

import json
import warnings
from pathlib import Path
from collections import deque
from typing import Dict, List, Tuple

from PIL import Image, ImageDraw


ROOT = Path(__file__).resolve().parents[4]
DOC_DIR = ROOT / "docs/collaboration/round172_visual_rebuild_asset_generation/anchor_props_a_m"
ASSET_DIR = ROOT / "assets/art/visual_rebuild/round172/anchor_props_a_m"
NORMALIZED_DIR = ASSET_DIR / "normalized_128x128"
RAW_PATH = DOC_DIR / "round172_anchor_props_a_m_raw_chroma_sheet_v001.png"
ATLAS_PATH = ASSET_DIR / "round172_anchor_props_a_m_128x128_atlas_v001.png"
PROOF_PATH = ASSET_DIR / "round172_anchor_props_a_m_128x128_proof_v001.png"
MANIFEST_PATH = ASSET_DIR / "round172_anchor_props_a_m_manifest_v001.json"

CELL = 128
SOURCE_CELL = 256
GRID = 4
MAX_SUBJECT = 112
KEY = (0, 255, 0)

warnings.filterwarnings("ignore", category=DeprecationWarning)


ITEMS: List[Dict[str, str]] = [
    {
        "letter": "A",
        "anchor_id": "anchor_a_apple",
        "core_word": "Apple",
        "visual_hook": "apple welcome box with low apple sapling and red apple sticker shape",
        "az_world_place_id": "place_home",
        "runtime_place_id": "place_home",
    },
    {
        "letter": "B",
        "anchor_id": "anchor_b_bear",
        "core_word": "Bear",
        "visual_hook": "bear-shaped bookshop story sign with warm lamp and open book",
        "az_world_place_id": "place_bookshop",
        "runtime_place_id": "place_town_start",
    },
    {
        "letter": "C",
        "anchor_id": "anchor_c_clock",
        "core_word": "Clock",
        "visual_hook": "round morning clock on small cozy table with sun tick shapes",
        "az_world_place_id": "place_home_watch_table",
        "runtime_place_id": "place_home",
    },
    {
        "letter": "D",
        "anchor_id": "anchor_d_dog",
        "core_word": "Dog",
        "visual_hook": "Sunny dog corner with small pet bed, bowl, paw prints, and low fence",
        "az_world_place_id": "place_home_sunny_corner",
        "runtime_place_id": "place_home",
    },
    {
        "letter": "E",
        "anchor_id": "anchor_e_elephant",
        "core_word": "Elephant",
        "visual_hook": "elephant playground slide with round ears and safe mat",
        "az_world_place_id": "place_playground",
        "runtime_place_id": "place_animal_park",
    },
    {
        "letter": "F",
        "anchor_id": "anchor_f_fox",
        "core_word": "Fox",
        "visual_hook": "fox topiary bush beside small flowers",
        "az_world_place_id": "place_garden",
        "runtime_place_id": "place_animal_park",
    },
    {
        "letter": "G",
        "anchor_id": "anchor_g_gate",
        "core_word": "Gate",
        "visual_hook": "rounded school gate arch with tiny bell and bunting",
        "az_world_place_id": "place_school_gate",
        "runtime_place_id": "place_school_gate",
    },
    {
        "letter": "H",
        "anchor_id": "anchor_h_hat",
        "core_word": "Hat",
        "visual_hook": "giant hat shop awning prop with ribbon and hat display",
        "az_world_place_id": "place_clothes_shop",
        "runtime_place_id": "place_supermarket",
    },
    {
        "letter": "I",
        "anchor_id": "anchor_i_ice_cream",
        "core_word": "Ice cream",
        "visual_hook": "ice cream cart with umbrella and cone icon shape",
        "az_world_place_id": "place_shop_street",
        "runtime_place_id": "place_supermarket",
    },
    {
        "letter": "J",
        "anchor_id": "anchor_j_jacket",
        "core_word": "Jacket",
        "visual_hook": "jacket shop-window display with hanger and raindrop stickers",
        "az_world_place_id": "place_clothes_shop",
        "runtime_place_id": "place_supermarket",
    },
    {
        "letter": "K",
        "anchor_id": "anchor_k_kite",
        "core_word": "Kite",
        "visual_hook": "kite on short display pole with colorful streamers and wind flag",
        "az_world_place_id": "place_school_yard",
        "runtime_place_id": "place_school_yard",
    },
    {
        "letter": "L",
        "anchor_id": "anchor_l_lion",
        "core_word": "Lion",
        "visual_hook": "lion fountain statue with book-page-shaped water motif",
        "az_world_place_id": "place_bookshop",
        "runtime_place_id": "place_animal_park",
    },
    {
        "letter": "M",
        "anchor_id": "anchor_m_monkey",
        "core_word": "Monkey",
        "visual_hook": "park tree monkey installation hugging a branch with low wooden base",
        "az_world_place_id": "place_park",
        "runtime_place_id": "place_animal_park",
    },
]


def rel(path: Path) -> str:
    return str(path.relative_to(ROOT))


def key_to_alpha(img: Image.Image) -> Image.Image:
    rgba = img.convert("RGBA")
    px = rgba.load()
    for y in range(rgba.height):
        for x in range(rgba.width):
            r, g, b, a = px[x, y]
            # Generated chroma backgrounds vary slightly; keep natural foliage by requiring very high G
            # and very low red/blue, then softly remove the antialiased key edge.
            if g >= 235 and r <= 80 and b <= 80:
                px[x, y] = (0, 0, 0, 0)
            elif g >= 215 and r <= 110 and b <= 110:
                px[x, y] = (r, min(g, 210), b, max(0, int(a * 0.25)))
    return rgba


def alpha_bbox(img: Image.Image) -> Tuple[int, int, int, int] | None:
    return img.getchannel("A").getbbox()


def normalize_cell(cell_img: Image.Image) -> Tuple[Image.Image, Dict[str, object]]:
    cleared = key_to_alpha(cell_img)
    bbox = alpha_bbox(cleared)
    out = Image.new("RGBA", (CELL, CELL), (0, 0, 0, 0))
    if bbox is None:
        return out, {"bbox": None, "opaque_pixels": 0, "visible_key_pixels": 0}

    subject = cleared.crop(bbox)
    scale = min(MAX_SUBJECT / subject.width, MAX_SUBJECT / subject.height, 1.0)
    new_size = (max(1, int(subject.width * scale)), max(1, int(subject.height * scale)))
    subject = subject.resize(new_size, Image.Resampling.LANCZOS)
    x = (CELL - new_size[0]) // 2
    y = CELL - new_size[1] - 8
    out.alpha_composite(subject, (x, y))
    remove_exact_visible_key(out)
    final_bbox = alpha_bbox(out)
    return out, {
        "bbox": list(final_bbox) if final_bbox else None,
        "opaque_pixels": count_opaque(out),
        "visible_key_pixels": count_visible_key(out),
    }


def normalize_cutout(cutout: Image.Image) -> Tuple[Image.Image, Dict[str, object]]:
    bbox = alpha_bbox(cutout)
    out = Image.new("RGBA", (CELL, CELL), (0, 0, 0, 0))
    if bbox is None:
        return out, {"bbox": None, "opaque_pixels": 0, "visible_key_pixels": 0}

    subject = cutout.crop(bbox)
    scale = min(MAX_SUBJECT / subject.width, MAX_SUBJECT / subject.height, 1.0)
    new_size = (max(1, int(subject.width * scale)), max(1, int(subject.height * scale)))
    subject = subject.resize(new_size, Image.Resampling.LANCZOS)
    x = (CELL - new_size[0]) // 2
    y = CELL - new_size[1] - 8
    out.alpha_composite(subject, (x, y))
    remove_exact_visible_key(out)
    final_bbox = alpha_bbox(out)
    return out, {
        "bbox": list(final_bbox) if final_bbox else None,
        "opaque_pixels": count_opaque(out),
        "visible_key_pixels": count_visible_key(out),
    }


def extract_assigned_cutouts(raw: Image.Image) -> List[Image.Image]:
    alpha_full = key_to_alpha(raw)
    alpha = alpha_full.getchannel("A")
    width, height = alpha_full.size
    alpha_data = alpha.load()
    visited = bytearray(width * height)
    masks = [Image.new("L", (width, height), 0) for _ in ITEMS]
    centers = [
        ((idx % GRID) * SOURCE_CELL + SOURCE_CELL / 2.0, (idx // GRID) * SOURCE_CELL + SOURCE_CELL / 2.0)
        for idx in range(len(ITEMS))
    ]

    def nearest_item(cx: float, cy: float) -> int:
        best_idx = 0
        best_dist = 10**12
        for i, (ix, iy) in enumerate(centers):
            dist = (cx - ix) ** 2 + (cy - iy) ** 2
            if dist < best_dist:
                best_dist = dist
                best_idx = i
        return best_idx

    for start_y in range(height):
        for start_x in range(width):
            pos = start_y * width + start_x
            if visited[pos] or alpha_data[start_x, start_y] == 0:
                continue
            visited[pos] = 1
            queue = deque([(start_x, start_y)])
            pixels: List[Tuple[int, int]] = []
            sum_x = 0
            sum_y = 0
            while queue:
                x, y = queue.popleft()
                pixels.append((x, y))
                sum_x += x
                sum_y += y
                for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                    if nx < 0 or ny < 0 or nx >= width or ny >= height:
                        continue
                    npos = ny * width + nx
                    if visited[npos] or alpha_data[nx, ny] == 0:
                        continue
                    visited[npos] = 1
                    queue.append((nx, ny))
            if len(pixels) < 12:
                continue
            target = nearest_item(sum_x / len(pixels), sum_y / len(pixels))
            mask_px = masks[target].load()
            for x, y in pixels:
                mask_px[x, y] = 255

    cutouts: List[Image.Image] = []
    for mask in masks:
        cutout = Image.new("RGBA", alpha_full.size, (0, 0, 0, 0))
        cutout.paste(alpha_full, (0, 0), mask)
        cutouts.append(cutout)
    return cutouts


def count_opaque(img: Image.Image) -> int:
    return sum(1 for alpha in img.getchannel("A").getdata() if alpha > 0)


def remove_exact_visible_key(img: Image.Image) -> None:
    px = img.load()
    for y in range(img.height):
        for x in range(img.width):
            r, g, b, a = px[x, y]
            if a > 0 and (r, g, b) == KEY:
                px[x, y] = (0, 0, 0, 0)


def count_visible_key(img: Image.Image) -> int:
    data = img.convert("RGBA").getdata()
    return sum(1 for r, g, b, a in data if a > 0 and (r, g, b) == KEY)


def checkerboard(size: Tuple[int, int], tile: int = 16) -> Image.Image:
    img = Image.new("RGBA", size, (244, 240, 228, 255))
    draw = ImageDraw.Draw(img)
    for y in range(0, size[1], tile):
        for x in range(0, size[0], tile):
            if ((x // tile) + (y // tile)) % 2:
                draw.rectangle([x, y, x + tile - 1, y + tile - 1], fill=(214, 221, 210, 255))
    return img


def main() -> None:
    NORMALIZED_DIR.mkdir(parents=True, exist_ok=True)
    raw = Image.open(RAW_PATH).convert("RGB")
    cutouts = extract_assigned_cutouts(raw)

    atlas = Image.new("RGBA", (CELL * GRID, CELL * GRID), (0, 0, 0, 0))
    proof = checkerboard((CELL * GRID, CELL * GRID))
    manifest_items: List[Dict[str, object]] = []

    for idx, item in enumerate(ITEMS):
        normalized, metrics = normalize_cutout(cutouts[idx])
        word_slug = item["core_word"].lower().replace(" ", "_")
        filename = f"anchor_prop_{item['letter'].lower()}_{word_slug}_128x128.png"
        out_path = NORMALIZED_DIR / filename
        normalized.save(out_path)
        dx = (idx % GRID) * CELL
        dy = (idx // GRID) * CELL
        atlas.alpha_composite(normalized, (dx, dy))
        proof.alpha_composite(normalized, (dx, dy))

        place_mismatch = item["az_world_place_id"] != item["runtime_place_id"]
        manifest_items.append(
            {
                **item,
                "status": "normalized_candidate",
                "normalized_png": rel(out_path),
                "atlas_cell": {"x": idx % GRID, "y": idx // GRID, "w": CELL, "h": CELL},
                "source_cell": {"x": idx % GRID, "y": idx // GRID, "w": SOURCE_CELL, "h": SOURCE_CELL},
                "metrics": metrics,
                "anchor_place_mismatch_risk": place_mismatch,
            }
        )

    atlas.save(ATLAS_PATH)
    proof_draw = ImageDraw.Draw(proof)
    for i in range(GRID + 1):
        p = i * CELL
        proof_draw.line([(p, 0), (p, CELL * GRID)], fill=(92, 87, 76, 180), width=1)
        proof_draw.line([(0, p), (CELL * GRID, p)], fill=(92, 87, 76, 180), width=1)
    proof.save(PROOF_PATH)

    atlas_alpha = atlas.getchannel("A")
    fixed_cell = atlas.size == (CELL * GRID, CELL * GRID)
    alpha = atlas.mode == "RGBA" and atlas_alpha.getextrema()[0] == 0 and atlas_alpha.getextrema()[1] > 0
    all_bbox = all(item["metrics"]["bbox"] is not None for item in manifest_items)
    visible_key_pixels = count_visible_key(atlas)
    overall_gate = fixed_cell and alpha and all_bbox and visible_key_pixels == 0

    manifest = {
        "round": "Round172",
        "pack_id": "round172_anchor_props_a_m",
        "status": "candidate_only",
        "runtime_boundary": "candidate_only_no_asset_resolver_or_themeprofile_mapping",
        "source_data": [
            "data/maps/az_world_plan.json",
            "data/anchors/az_core_anchors.json",
            "data/cards/az_core_cards.json",
            "data/maps/world_map.json",
        ],
        "source_raw": rel(RAW_PATH),
        "atlas": rel(ATLAS_PATH),
        "proof": rel(PROOF_PATH),
        "cell_size": {"w": CELL, "h": CELL},
        "atlas_grid": {"columns": GRID, "rows": GRID, "used_cells": len(ITEMS), "empty_cells": 3},
        "normalization": {
            "method": "4x4 source cell crop, chroma-key alpha removal, bbox fit, bottom-centered 128x128 fixed cell",
            "key_color": "#00ff00",
            "max_subject_px": MAX_SUBJECT,
        },
        "gate_checks": {
            "fixed_cell": fixed_cell,
            "alpha": alpha,
            "all_items_have_bbox": all_bbox,
            "visible_key_pixels": visible_key_pixels,
        },
        "overall_gate": "pass" if overall_gate else "fail",
        "items": manifest_items,
        "anchor_mismatch_risk": "present_for_place_granularity_only" if any(i["anchor_place_mismatch_risk"] for i in manifest_items) else "none",
        "notes": [
            "Proof-only candidate pack; no runtime, ThemeProfile, AssetResolver, data, or test mapping.",
            "No bare letter signs or in-image text were intentionally generated; items are prop-first visual hooks.",
            "A-Z stable anchor_id, letter, core_word, and route_order are sourced from public project data.",
        ],
    }
    MANIFEST_PATH.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps(manifest["gate_checks"], indent=2))
    print(f"overall_gate={manifest['overall_gate']}")
    print(f"manifest={rel(MANIFEST_PATH)}")


if __name__ == "__main__":
    main()
