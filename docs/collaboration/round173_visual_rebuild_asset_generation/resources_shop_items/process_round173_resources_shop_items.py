#!/usr/bin/env python3
from __future__ import annotations

import json
from pathlib import Path
from typing import Dict, List, Tuple

from PIL import Image, ImageChops, ImageDraw


ROOT = Path(__file__).resolve().parents[4]
DOC_DIR = ROOT / "docs/collaboration/round173_visual_rebuild_asset_generation/resources_shop_items"
ASSET_DIR = ROOT / "assets/art/visual_rebuild/round173/resources_shop_items"
RAW_SHEET = DOC_DIR / "resources_shop_items_raw_sheet_magenta.png"

CELL_SIZE = 128
COLS = 5
ROWS = 2
KEY = (255, 0, 255)
ITEMS = [
    ("branch_bundle", "resource_shop_item", "resource_exchange", "shop_branch_bundle_001"),
    ("pebble_pair", "resource_shop_item", "resource_exchange", "shop_pebble_pair_001"),
    ("wildflower_small", "resource_shop_item", "resource_exchange", "shop_wildflower_small_001"),
    ("orange_bowl_or_orange_tag", "resource_shop_item", "decor_small_or_shop_anchor", "daily_shopkeeper_orange_sign_001"),
    ("pet_food", "resource_shop_item", "pet_care", "shop_pet_bowl_sunny_001"),
    ("sunny_snack_basket", "resource_shop_item", "pet_care", "shop_sunny_snack_basket_001"),
    ("fabric_scrap", "resource_shop_item", "resource_exchange", "future_fabric_scrap_material"),
    ("book_stack_or_story_book", "resource_shop_item", "decor_small", "shop_tiny_book_stack_001"),
    ("coin_stack", "resource_shop_item", "currency_icon", "ui_icon.coin"),
    ("tiny_seed_packet", "resource_shop_item", "resource_exchange", "future_tiny_seed_packet_material"),
]


def rel(path: Path) -> str:
    return path.relative_to(ROOT).as_posix()


def key_to_alpha(img: Image.Image) -> Image.Image:
    rgba = img.convert("RGBA")
    pixels = rgba.load()
    width, height = rgba.size
    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            dr = abs(r - KEY[0])
            dg = abs(g - KEY[1])
            db = abs(b - KEY[2])
            dist = max(dr, dg, db)
            if dist <= 18:
                pixels[x, y] = (0, 0, 0, 0)
            elif dist <= 64:
                alpha = int(255 * (dist - 18) / (64 - 18))
                # Despill magenta edges without changing opaque subject colors.
                nr = min(r, int((g + b) / 2) + 30)
                nb = min(b, int((r + g) / 2) + 30)
                pixels[x, y] = (nr, g, nb, min(a, alpha))
    return rgba


def alpha_bbox(img: Image.Image) -> Tuple[int, int, int, int] | None:
    alpha = img.getchannel("A")
    return alpha.getbbox()


def normalize_icon(cell: Image.Image) -> Tuple[Image.Image, Tuple[int, int, int, int]]:
    bbox = alpha_bbox(cell)
    if bbox is None:
        raise RuntimeError("empty cell")
    cropped = cell.crop(bbox)
    max_dim = max(cropped.size)
    target_subject = 106
    scale = target_subject / max_dim
    new_size = (max(1, round(cropped.width * scale)), max(1, round(cropped.height * scale)))
    resized = cropped.resize(new_size, Image.Resampling.LANCZOS)
    out = Image.new("RGBA", (CELL_SIZE, CELL_SIZE), (0, 0, 0, 0))
    x = (CELL_SIZE - resized.width) // 2
    y = (CELL_SIZE - resized.height) // 2
    out.alpha_composite(resized, (x, y))
    clean_key_rgb(out)
    bbox_out = alpha_bbox(out)
    if bbox_out is None:
        raise RuntimeError("empty normalized icon")
    return out, bbox_out


def clean_key_rgb(img: Image.Image) -> None:
    pixels = img.load()
    width, height = img.size
    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            if a == 0 or (r, g, b) == KEY:
                pixels[x, y] = (0, 0, 0, 0)


def count_key_pixels(img: Image.Image, visible_only: bool = True) -> int:
    rgba = img.convert("RGBA")
    count = 0
    pixels = rgba.load()
    width, height = rgba.size
    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            if visible_only and a == 0:
                continue
            if (r, g, b) == KEY:
                count += 1
    return count


def image_stats(path: Path, logical_id: str, bbox: Tuple[int, int, int, int]) -> Dict:
    img = Image.open(path).convert("RGBA")
    alpha = img.getchannel("A")
    alpha_histogram = alpha.histogram()
    transparent_pixels = alpha_histogram[0]
    opaqueish_pixels = sum(alpha_histogram[1:])
    has_alpha = img.mode == "RGBA"
    fixed_cell = img.size == (CELL_SIZE, CELL_SIZE)
    return {
        "id": logical_id,
        "normalized_png": rel(path),
        "cell_size": [CELL_SIZE, CELL_SIZE],
        "fixed_cell": fixed_cell,
        "has_alpha": has_alpha,
        "transparent_pixels": transparent_pixels,
        "opaqueish_pixels": opaqueish_pixels,
        "bbox": list(bbox),
        "has_bbox": opaqueish_pixels > 0 and bbox is not None,
        "visible_key_pixels": count_key_pixels(img, True),
    }


def make_checker(size: Tuple[int, int]) -> Image.Image:
    img = Image.new("RGB", size, (238, 232, 222))
    draw = ImageDraw.Draw(img)
    step = 16
    for y in range(0, size[1], step):
        for x in range(0, size[0], step):
            if (x // step + y // step) % 2 == 0:
                draw.rectangle([x, y, x + step - 1, y + step - 1], fill=(210, 226, 216))
    return img.convert("RGBA")


def write_readme(manifest: Dict) -> None:
    lines = [
        "# Round173 Resources / Shop Items Proof Pack",
        "",
        "Proof-only candidate item icons for V02.39 visual rebuild.",
        "",
        f"- Category: `{manifest['category']}`",
        f"- Runtime boundary: `{manifest['runtime_boundary']}`",
        f"- Overall gate: `{manifest['overall_gate']}`",
        f"- Atlas: `{manifest['atlas']}`",
        f"- Proof image: `{manifest['proof']}`",
        "- Normalized cell: `128x128`, transparent PNG, fixed-cell atlas.",
        "- Source/raw evidence remains in this collaboration folder.",
        "",
        "No ThemeProfile, AssetResolver, runtime, data, or test mapping is included.",
        "",
        "## Items",
        "",
    ]
    for item in manifest["items"]:
        lines.append(
            f"- `{item['id']}` -> `{item['normalized_png']}`; bbox={item['bbox']}; visible_key_pixels={item['visible_key_pixels']}"
        )
    lines.extend(
        [
            "",
            "## Validation",
            "",
            "Run from repo root:",
            "",
            "```bash",
            "python3 docs/collaboration/round173_visual_rebuild_asset_generation/resources_shop_items/process_round173_resources_shop_items.py",
            "```",
            "",
            "Gate requires fixed 128x128 cells, alpha, non-empty bbox, and zero visible #ff00ff key pixels.",
            "",
        ]
    )
    (DOC_DIR / "README.md").write_text("\n".join(lines), encoding="utf-8")
    (ASSET_DIR / "README.md").write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    ASSET_DIR.mkdir(parents=True, exist_ok=True)
    DOC_DIR.mkdir(parents=True, exist_ok=True)

    raw = Image.open(RAW_SHEET).convert("RGB")
    raw_w, raw_h = raw.size
    step_x = raw_w / COLS
    step_y = raw_h / ROWS

    atlas = Image.new("RGBA", (COLS * CELL_SIZE, ROWS * CELL_SIZE), (0, 0, 0, 0))
    proof = make_checker((COLS * CELL_SIZE, ROWS * CELL_SIZE))
    stats: List[Dict] = []

    for idx, (logical_id, category, subcategory, source_ref) in enumerate(ITEMS):
        col = idx % COLS
        row = idx // COLS
        crop_box = (
            round(col * step_x),
            round(row * step_y),
            round((col + 1) * step_x),
            round((row + 1) * step_y),
        )
        keyed_cell = raw.crop(crop_box)
        alpha_cell = key_to_alpha(keyed_cell)
        icon, bbox = normalize_icon(alpha_cell)
        icon_path = ASSET_DIR / f"{logical_id}.png"
        icon.save(icon_path)
        atlas.alpha_composite(icon, (col * CELL_SIZE, row * CELL_SIZE))
        proof.alpha_composite(icon, (col * CELL_SIZE, row * CELL_SIZE))
        item_stats = image_stats(icon_path, logical_id, bbox)
        item_stats.update(
            {
                "category": category,
                "subcategory": subcategory,
                "source_ref": source_ref,
                "atlas_cell": {"col": col, "row": row, "x": col * CELL_SIZE, "y": row * CELL_SIZE},
                "source_raw_crop": rel(RAW_SHEET),
            }
        )
        stats.append(item_stats)

    draw = ImageDraw.Draw(proof)
    for x in range(0, proof.width + 1, CELL_SIZE):
        draw.line([(x, 0), (x, proof.height)], fill=(92, 84, 72, 180), width=1)
    for y in range(0, proof.height + 1, CELL_SIZE):
        draw.line([(0, y), (proof.width, y)], fill=(92, 84, 72, 180), width=1)

    atlas_path = ASSET_DIR / "resources_shop_items_atlas_128.png"
    proof_path = ASSET_DIR / "resources_shop_items_proof_128.png"
    atlas.save(atlas_path)
    proof.save(proof_path)

    atlas_stats = {
        "fixed_cell": atlas.size == (COLS * CELL_SIZE, ROWS * CELL_SIZE),
        "has_alpha": atlas.mode == "RGBA",
        "visible_key_pixels": count_key_pixels(atlas, True),
        "bbox": list(alpha_bbox(atlas) or ()),
    }
    all_pass = (
        atlas_stats["fixed_cell"]
        and atlas_stats["has_alpha"]
        and atlas_stats["visible_key_pixels"] == 0
        and all(i["fixed_cell"] and i["has_alpha"] and i["has_bbox"] and i["visible_key_pixels"] == 0 for i in stats)
    )

    manifest = {
        "round": "Round173",
        "category": "resource_shop_item",
        "runtime_boundary": "candidate_only_no_asset_resolver_or_themeprofile_mapping",
        "overall_gate": "pass" if all_pass else "fail",
        "cell_size": [CELL_SIZE, CELL_SIZE],
        "atlas_grid": {"columns": COLS, "rows": ROWS},
        "chroma_key": "#ff00ff",
        "atlas": rel(atlas_path),
        "proof": rel(proof_path),
        "source_raw": rel(RAW_SHEET),
        "items": stats,
        "atlas_validation": atlas_stats,
        "validation_rule": "overall_gate pass only when fixed cell, alpha, bbox, and visible key pixels=0",
    }

    manifest_path = ASSET_DIR / "resources_shop_items_manifest.json"
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    (DOC_DIR / "resources_shop_items_manifest.copy.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    write_readme(manifest)
    print(json.dumps({"manifest": rel(manifest_path), "overall_gate": manifest["overall_gate"], "items": len(stats)}, indent=2))


if __name__ == "__main__":
    main()
