from __future__ import annotations

import json
import warnings
from collections import deque
from pathlib import Path
from typing import Dict, List, Tuple

from PIL import Image, ImageDraw


ROOT = Path(__file__).resolve().parents[4]
DOC_DIR = ROOT / "docs/collaboration/round172_visual_rebuild_asset_generation/anchor_props_n_z"
ASSET_DIR = ROOT / "assets/art/visual_rebuild/round172/anchor_props_n_z"
NORMALIZED_DIR = ASSET_DIR / "normalized_128x128"
RAW_PATH = DOC_DIR / "round172_anchor_props_n_z_raw_chroma_ff00ff_4x4_v001.png"
ATLAS_PATH = ASSET_DIR / "round172_anchor_props_n_z_128x128_atlas_v001.png"
PROOF_PATH = ASSET_DIR / "round172_anchor_props_n_z_128x128_proof_v001.png"
MANIFEST_PATH = ASSET_DIR / "round172_anchor_props_n_z_manifest_v001.json"

CELL = 128
SOURCE_CELL = 256
GRID = 4
MAX_SUBJECT = 112
KEY = (255, 0, 255)

warnings.filterwarnings("ignore", category=DeprecationWarning)


ITEMS: List[Dict[str, str]] = [
    {
        "letter": "N",
        "anchor_id": "anchor_n_net",
        "core_word": "Net",
        "visual_hook": "soft sports net with leaves and low rounded supports",
        "az_world_place_id": "place_sports_corner",
        "runtime_place_id": "place_school_yard",
    },
    {
        "letter": "O",
        "anchor_id": "anchor_o_orange",
        "core_word": "Orange",
        "visual_hook": "orange basket with juice bottle and round orange shop token",
        "az_world_place_id": "place_supermarket",
        "runtime_place_id": "place_supermarket",
    },
    {
        "letter": "P",
        "anchor_id": "anchor_p_panda",
        "core_word": "Panda",
        "visual_hook": "panda cushion with bamboo leaf coaster and tiny tea table",
        "az_world_place_id": "place_bookshop",
        "runtime_place_id": "place_animal_park",
    },
    {
        "letter": "Q",
        "anchor_id": "anchor_q_queen",
        "core_word": "Queen",
        "visual_hook": "crown-shaped theatre prop with star stickers and folded curtain swatch",
        "az_world_place_id": "place_theatre",
        "runtime_place_id": "place_town_start",
    },
    {
        "letter": "R",
        "anchor_id": "anchor_r_robot",
        "core_word": "Robot",
        "visual_hook": "friendly rounded robot direction prop with small chest light and toolbox",
        "az_world_place_id": "place_school_yard",
        "runtime_place_id": "place_school_yard",
    },
    {
        "letter": "S",
        "anchor_id": "anchor_s_sun",
        "core_word": "Sun",
        "visual_hook": "warm sun patch ornament with soft ground cushion and tiny sun decor",
        "az_world_place_id": "place_park",
        "runtime_place_id": "place_sun_scene",
    },
    {
        "letter": "T",
        "anchor_id": "anchor_t_taxi",
        "core_word": "Taxi",
        "visual_hook": "toy-like yellow taxi waiting marker with bus-stop pole shape",
        "az_world_place_id": "place_bus_stop",
        "runtime_place_id": "place_home",
    },
    {
        "letter": "U",
        "anchor_id": "anchor_u_umbrella",
        "core_word": "Umbrella",
        "visual_hook": "park umbrella with bench and small rain and sun charms",
        "az_world_place_id": "place_park",
        "runtime_place_id": "place_coast_edge",
    },
    {
        "letter": "V",
        "anchor_id": "anchor_v_violin",
        "core_word": "Violin",
        "visual_hook": "violin leaning on tiny stage rug with note-shaped lamp",
        "az_world_place_id": "place_music_corner",
        "runtime_place_id": "place_town_start",
    },
    {
        "letter": "W",
        "anchor_id": "anchor_w_watch",
        "core_word": "Watch",
        "visual_hook": "small watch on cozy home note paper without readable text",
        "az_world_place_id": "place_home_watch_table",
        "runtime_place_id": "place_home",
    },
    {
        "letter": "X",
        "anchor_id": "anchor_x_x_mark_box",
        "core_word": "X-mark Box",
        "visual_hook": "rounded lost-and-found box with crossed tape shape and stickers",
        "az_world_place_id": "place_airport_cargo",
        "runtime_place_id": "place_coast_edge",
    },
    {
        "letter": "Y",
        "anchor_id": "anchor_y_yo_yo",
        "core_word": "Yo-yo",
        "visual_hook": "hanging yo-yo with colorful string and storage box",
        "az_world_place_id": "place_school_yard",
        "runtime_place_id": "place_school_yard",
    },
    {
        "letter": "Z",
        "anchor_id": "anchor_z_zebra",
        "core_word": "Zebra",
        "visual_hook": "zebra-pattern garden prop with curved stripe marker and flower bed",
        "az_world_place_id": "place_zoo_edge",
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
            if r >= 225 and b >= 225 and g <= 95:
                px[x, y] = (0, 0, 0, 0)
            elif r >= 205 and b >= 205 and g <= 130:
                px[x, y] = (min(r, 190), g, min(b, 190), max(0, int(a * 0.25)))
    return rgba


def alpha_bbox(img: Image.Image) -> Tuple[int, int, int, int] | None:
    return img.getchannel("A").getbbox()


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


def checkerboard(size: Tuple[int, int], tile: int = 16) -> Image.Image:
    img = Image.new("RGBA", size, (244, 240, 228, 255))
    draw = ImageDraw.Draw(img)
    for y in range(0, size[1], tile):
        for x in range(0, size[0], tile):
            if ((x // tile) + (y // tile)) % 2:
                draw.rectangle([x, y, x + tile - 1, y + tile - 1], fill=(214, 221, 210, 255))
    return img


def slug(core_word: str) -> str:
    return core_word.lower().replace("-", "_").replace(" ", "_")


def main() -> None:
    NORMALIZED_DIR.mkdir(parents=True, exist_ok=True)
    raw = Image.open(RAW_PATH).convert("RGB")
    cutouts = extract_assigned_cutouts(raw)

    atlas = Image.new("RGBA", (CELL * GRID, CELL * GRID), (0, 0, 0, 0))
    proof = checkerboard((CELL * GRID, CELL * GRID))
    manifest_items: List[Dict[str, object]] = []

    for idx, item in enumerate(ITEMS):
        normalized, metrics = normalize_cutout(cutouts[idx])
        filename = f"anchor_prop_{item['letter'].lower()}_{slug(item['core_word'])}_128x128.png"
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
        "pack_id": "round172_anchor_props_n_z",
        "status": "candidate_only",
        "runtime_boundary": "candidate_only_no_asset_resolver_or_themeprofile_mapping",
        "source_data": [
            "data/maps/az_world_plan.json",
            "data/maps/world_map.json",
        ],
        "source_raw": rel(RAW_PATH),
        "atlas": rel(ATLAS_PATH),
        "proof": rel(PROOF_PATH),
        "cell_size": {"w": CELL, "h": CELL},
        "atlas_grid": {"columns": GRID, "rows": GRID, "used_cells": len(ITEMS), "empty_cells": 3},
        "normalization": {
            "method": "4x4 generated source sheet, chroma-key alpha removal, connected-component assignment, bbox fit, bottom-centered 128x128 fixed cell",
            "key_color": "#ff00ff",
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
            "Proof-only N-Z candidate pack; no runtime, ThemeProfile, AssetResolver, data, or test mapping.",
            "No bare letter plaques or intentional in-image text; props are visual hooks for stable memory-palace anchors.",
            "Stable anchor_id, letter, core_word, and route identity were read from public project map data.",
        ],
    }
    MANIFEST_PATH.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps(manifest["gate_checks"], indent=2))
    print(f"overall_gate={manifest['overall_gate']}")
    print(f"manifest={rel(MANIFEST_PATH)}")


if __name__ == "__main__":
    main()
