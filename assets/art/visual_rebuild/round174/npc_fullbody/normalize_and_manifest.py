#!/usr/bin/env python3
from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from PIL import Image, ImageDraw


ROOT = Path(__file__).resolve().parent
RAW_DIR = ROOT / "raw_chroma"
NORM_DIR = ROOT / "normalized_160x192"
PROOF_DIR = ROOT / "proof"
MANIFEST = ROOT / "round174_npc_fullbody_manifest_v001.json"
PROMPTS = ROOT / "source_prompts.json"

CELL_W = 160
CELL_H = 192
BASELINE_Y = 176
PIVOT = [80, BASELINE_Y]
ATLAS = ROOT / "round174_npc_fullbody_160x192_atlas_v001.png"
PROOF = PROOF_DIR / "round174_npc_fullbody_checker_proof_v001.png"


def alpha_bbox(im: Image.Image) -> tuple[int, int, int, int] | None:
    return im.getchannel("A").getbbox()


def ensure_alpha(im: Image.Image) -> Image.Image:
    im = im.convert("RGBA")
    if alpha_bbox(im) and alpha_bbox(im) != (0, 0, im.width, im.height):
        return im

    pixels = im.load()
    corners = [
        pixels[0, 0],
        pixels[im.width - 1, 0],
        pixels[0, im.height - 1],
        pixels[im.width - 1, im.height - 1],
    ]
    key = max(set(corners), key=corners.count)
    out = im.copy()
    key_kind = "generic"
    if sum(1 for r, g, b, _a in corners if is_magenta_key(r, g, b)) >= 2:
        key_kind = "magenta"
    elif sum(1 for r, g, b, _a in corners if is_green_key(r, g, b)) >= 2:
        key_kind = "green"

    data = []
    for r, g, b, a in pixel_data(out):
        dist = abs(r - key[0]) + abs(g - key[1]) + abs(b - key[2])
        if key_kind == "magenta" and is_magenta_key(r, g, b):
            data.append((r, g, b, 0))
        elif key_kind == "green" and is_green_key(r, g, b):
            data.append((r, g, b, 0))
        elif dist < 54:
            data.append((r, g, b, 0))
        else:
            data.append((r, g, b, a))
    out.putdata(data)
    return out


def is_magenta_key(r: int, g: int, b: int) -> bool:
    return r >= 220 and b >= 145 and g <= 145 and (r - g) >= 90 and (b - g) >= 45


def is_green_key(r: int, g: int, b: int) -> bool:
    return g >= 210 and r <= 95 and b <= 110 and (g - r) >= 110 and (g - b) >= 95


def count_edge_touch(bbox: tuple[int, int, int, int] | None) -> dict[str, int]:
    if not bbox:
        return {"top": 0, "bottom": 0, "left": 0, "right": 0}
    l, t, r, b = bbox
    return {
        "top": int(t <= 0),
        "bottom": int(b >= CELL_H),
        "left": int(l <= 0),
        "right": int(r >= CELL_W),
    }


def suspect_chroma_pixels(im: Image.Image) -> int:
    count = 0
    for r, g, b, a in pixel_data(im):
        if a < 16:
            continue
        green_key = g > 220 and r < 45 and b < 45
        magenta_key = r > 220 and b > 220 and g < 55
        if green_key or magenta_key:
            count += 1
    return count


def pixel_data(im: Image.Image):
    getter = getattr(im, "get_flattened_data", None)
    return getter() if getter else im.getdata()


def rectangular_background_metrics(im: Image.Image, bbox: tuple[int, int, int, int] | None) -> dict[str, Any]:
    if not bbox:
        return {
            "bbox_fill_ratio": 0.0,
            "top_edge_alpha_ratio": 0.0,
            "bottom_edge_alpha_ratio": 0.0,
            "left_edge_alpha_ratio": 0.0,
            "right_edge_alpha_ratio": 0.0,
            "max_edge_alpha_ratio": 0.0,
            "opaque_rectangular_block": False,
        }
    l, t, r, b = bbox
    width = max(1, r - l)
    height = max(1, b - t)
    alpha = im.getchannel("A")
    opaque = 0
    for y in range(t, b):
        for x in range(l, r):
            if alpha.getpixel((x, y)) >= 16:
                opaque += 1

    def row_ratio(y: int) -> float:
        return sum(1 for x in range(l, r) if alpha.getpixel((x, y)) >= 16) / width

    def col_ratio(x: int) -> float:
        return sum(1 for y in range(t, b) if alpha.getpixel((x, y)) >= 16) / height

    top = row_ratio(t)
    bottom = row_ratio(b - 1)
    left = col_ratio(l)
    right = col_ratio(r - 1)
    fill = opaque / (width * height)
    max_edge = max(top, bottom, left, right)
    edge_pairs = max(min(top, bottom), min(left, right))
    perimeter_average = (top + bottom + left + right) / 4.0
    block = max_edge > 0.62 or perimeter_average > 0.42 or edge_pairs > 0.34
    return {
        "bbox_fill_ratio": round(fill, 4),
        "top_edge_alpha_ratio": round(top, 4),
        "bottom_edge_alpha_ratio": round(bottom, 4),
        "left_edge_alpha_ratio": round(left, 4),
        "right_edge_alpha_ratio": round(right, 4),
        "max_edge_alpha_ratio": round(max_edge, 4),
        "perimeter_average_alpha_ratio": round(perimeter_average, 4),
        "opposing_edge_pair_alpha_ratio": round(edge_pairs, 4),
        "opaque_rectangular_block": bool(block),
    }


def normalize_item(item: dict[str, Any]) -> dict[str, Any]:
    raw_path = RAW_DIR / f"{item['id']}_raw.png"
    normalized_path = NORM_DIR / f"{item['id']}_160x192.png"
    if not raw_path.exists():
        return {
            "id": item["id"],
            "raw_png": str(raw_path.relative_to(Path.cwd())),
            "normalized_png": str(normalized_path.relative_to(Path.cwd())),
            "status": "fail_missing_raw",
            "source_prompt": item["prompt"],
            "risks": ["raw image was not generated"],
        }

    raw = ensure_alpha(Image.open(raw_path))
    bbox = alpha_bbox(raw)
    if not bbox:
        return {
            "id": item["id"],
            "raw_png": str(raw_path.relative_to(Path.cwd())),
            "normalized_png": str(normalized_path.relative_to(Path.cwd())),
            "status": "fail_empty_alpha",
            "source_prompt": item["prompt"],
            "risks": ["no visible opaque subject after alpha extraction"],
        }

    l, t, r, b = bbox
    crop = raw.crop(bbox)
    target_h = int(item["target_height_px"])
    max_w = 122 if item["id"] != "sunny_companion" else 92
    scale = min(target_h / crop.height, max_w / crop.width)
    new_w = max(1, round(crop.width * scale))
    new_h = max(1, round(crop.height * scale))
    resized = crop.resize((new_w, new_h), Image.Resampling.LANCZOS)

    canvas = Image.new("RGBA", (CELL_W, CELL_H), (0, 0, 0, 0))
    x = (CELL_W - new_w) // 2
    y = BASELINE_Y - new_h
    canvas.alpha_composite(resized, (x, y))
    canvas.save(normalized_path)

    nb = alpha_bbox(canvas)
    visible = sum(1 for *_, a in pixel_data(canvas) if a >= 16)
    transparent_corners = all(canvas.getpixel(p)[3] == 0 for p in [(0, 0), (159, 0), (0, 191), (159, 191)])
    chroma_count = suspect_chroma_pixels(canvas)
    risks: list[str] = []
    if chroma_count > 50:
        risks.append("possible chroma-colored fringe or subject pixels require visual review")
    if not transparent_corners:
        risks.append("one or more corners are not transparent")
    if nb:
        edge_touch = count_edge_touch(nb)
        if any(edge_touch.values()):
            risks.append("normalized subject touches cell edge")
    else:
        edge_touch = count_edge_touch(None)
    rect_metrics = rectangular_background_metrics(canvas, nb)
    if rect_metrics["opaque_rectangular_block"]:
        risks.append("opaque rectangular background or halo block detected")
    status = "pass"
    if rect_metrics["opaque_rectangular_block"]:
        status = "fail_visual_background_block"
    elif risks:
        status = "pass_with_review_risk"

    return {
        "id": item["id"],
        "logical_asset_id": f"actor.fullbody.{item['id']}",
        "raw_png": str(raw_path.relative_to(Path.cwd())),
        "normalized_png": str(normalized_path.relative_to(Path.cwd())),
        "cell_size": [CELL_W, CELL_H],
        "pivot_px": PIVOT,
        "baseline_y_px": BASELINE_Y,
        "target_height_px": target_h,
        "source_bbox_px": list(bbox),
        "normalized_bbox_px": list(nb) if nb else None,
        "opaque_pixel_count": visible,
        "transparent_corners": transparent_corners,
        "edge_touch_count": edge_touch,
        "rectangular_background_check": rect_metrics,
        "suspect_chroma_pixel_count": chroma_count,
        "has_alpha": True,
        "status": status,
        "asset_status": "normalized_candidate",
        "source_prompt": item["prompt"],
        "risks": risks,
    }


def make_checker(size: tuple[int, int], cell: int = 16) -> Image.Image:
    im = Image.new("RGBA", size, (255, 255, 255, 255))
    draw = ImageDraw.Draw(im)
    for y in range(0, size[1], cell):
        for x in range(0, size[0], cell):
            c = (224, 230, 228, 255) if ((x // cell) + (y // cell)) % 2 else (249, 250, 247, 255)
            draw.rectangle((x, y, x + cell - 1, y + cell - 1), fill=c)
    return im


def build_atlas_and_proof(items: list[dict[str, Any]]) -> None:
    atlas = Image.new("RGBA", (CELL_W * len(items), CELL_H), (0, 0, 0, 0))
    proof = make_checker((CELL_W * len(items), CELL_H + 24))
    draw = ImageDraw.Draw(proof)
    for index, item in enumerate(items):
        png = NORM_DIR / f"{item['id']}_160x192.png"
        if not png.exists():
            continue
        sprite = Image.open(png).convert("RGBA")
        x = index * CELL_W
        atlas.alpha_composite(sprite, (x, 0))
        proof.alpha_composite(sprite, (x, 0))
        draw.rectangle((x, 0, x + CELL_W - 1, CELL_H - 1), outline=(80, 120, 110, 255), width=1)
        draw.line((x, BASELINE_Y, x + CELL_W - 1, BASELINE_Y), fill=(224, 84, 72, 255), width=1)
        draw.text((x + 4, CELL_H + 4), item["id"][:18], fill=(40, 50, 48, 255))
    atlas.save(ATLAS)
    proof.save(PROOF)


def main() -> None:
    NORM_DIR.mkdir(parents=True, exist_ok=True)
    PROOF_DIR.mkdir(parents=True, exist_ok=True)
    source = json.loads(PROMPTS.read_text(encoding="utf-8"))
    results = [normalize_item(item) for item in source["items"]]
    build_atlas_and_proof(source["items"])

    pass_count = sum(1 for item in results if item["status"] == "pass")
    review_count = sum(1 for item in results if item["status"] == "pass_with_review_risk")
    fail_count = sum(1 for item in results if item["status"].startswith("fail"))
    visual_background_block_count = sum(
        1 for item in results
        if item.get("rectangular_background_check", {}).get("opaque_rectangular_block")
    )
    manifest = {
        "round": "Round174",
        "pack_id": "npc_fullbody",
        "status": "normalized_candidate_proof_only",
        "runtime_boundary": "candidate_only_no_asset_resolver_or_themeprofile_mapping",
        "category": "npc_companion_fullbody_standing",
        "cell_size": [CELL_W, CELL_H],
        "baseline_y_px": BASELINE_Y,
        "pivot_px": PIVOT,
        "atlas": str(ATLAS.relative_to(Path.cwd())),
        "proof": str(PROOF.relative_to(Path.cwd())),
        "raw_dir": str(RAW_DIR.relative_to(Path.cwd())),
        "normalized_dir": str(NORM_DIR.relative_to(Path.cwd())),
        "source_prompts": str(PROMPTS.relative_to(Path.cwd())),
        "generation_tool": source["generation_tool"],
        "generation_mode": source["generation_mode"],
        "style_intent": "original cozy town life-sim full-body standing sprites for children; warm but not storybook/card UI; soft 3/4 front poses; no embedded text",
        "round171_compatibility": {
            "cell_size_match": True,
            "baseline_y_match": True,
            "recommended_display_scale_reference": 0.72,
        },
        "gate_checks": {
            "fixed_cell": True,
            "atlas_dimensions_px": [CELL_W * len(results), CELL_H],
            "alpha": all(item.get("has_alpha") for item in results if not item["status"].startswith("fail")),
            "transparent_corners": all(item.get("transparent_corners") for item in results if not item["status"].startswith("fail")),
            "suspect_chroma_pixel_total": sum(item.get("suspect_chroma_pixel_count", 0) for item in results),
            "visual_background_block_count": visual_background_block_count,
            "visual_background_block_free": visual_background_block_count == 0,
            "pass_count": pass_count,
            "pass_with_review_risk_count": review_count,
            "fail_count": fail_count,
        },
        "overall_gate": "pass" if fail_count == 0 else "fail",
        "items": results,
        "risks": [
            "proof-only generated candidates; require art direction review before runtime use",
            "single standing pose only, not animation-ready",
            "generated character details may need consistency pass against final NPC canon",
        ],
    }
    MANIFEST.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps(manifest["gate_checks"], indent=2))


if __name__ == "__main__":
    main()
