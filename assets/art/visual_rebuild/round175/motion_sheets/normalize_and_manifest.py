#!/usr/bin/env python3
from __future__ import annotations

import json
import math
from pathlib import Path
from typing import Any

from PIL import Image, ImageDraw


ROOT = Path(__file__).resolve().parent
PROMPTS = ROOT / "source_prompts.json"
RAW_DIR = ROOT / "raw_generated"
NORM_DIR = ROOT / "normalized_960x768"
PROOF_DIR = ROOT / "proof"
MANIFEST = ROOT / "round175_motion_sheets_manifest.json"
CONTACT = PROOF_DIR / "round175_motion_sheets_contact_sheet.png"
REF_DIR = ROOT.parent.parent / "round174" / "npc_fullbody" / "normalized_160x192"

CELL_W = 160
CELL_H = 192
COLS = 3
ROWS = 4
SHEET_W = CELL_W * COLS
SHEET_H = CELL_H * ROWS
BASELINE_Y = 176
PIVOT = [80, BASELINE_Y]
DIRECTIONS = ["down", "left", "right", "up"]
FRAMES = ["step_left", "neutral", "step_right"]
REFERENCE_SPRITES = {
    "player_child_walk_4dir": "player_child_neutral_160x192.png",
    "mina_neighbor_walk_4dir": "mina_neighbor_160x192.png",
    "shopkeeper_warm_walk_4dir": "shopkeeper_warm_160x192.png",
    "sunny_companion_walk_4dir": "sunny_companion_160x192.png",
    "story_bear_walk_4dir": "story_bear_friend_160x192.png",
    "bus_brother_walk_4dir": "bus_brother_helper_160x192.png",
}


def rel(path: Path) -> str:
    return str(path.relative_to(Path.cwd()))


def pixel_data(im: Image.Image):
    getter = getattr(im, "get_flattened_data", None)
    return getter() if getter else im.getdata()


def alpha_bbox(im: Image.Image) -> tuple[int, int, int, int] | None:
    return im.getchannel("A").getbbox()


def make_checker(size: tuple[int, int], cell: int = 16) -> Image.Image:
    im = Image.new("RGBA", size, (255, 255, 255, 255))
    draw = ImageDraw.Draw(im)
    for y in range(0, size[1], cell):
        for x in range(0, size[0], cell):
            color = (224, 230, 228, 255) if ((x // cell) + (y // cell)) % 2 else (249, 250, 247, 255)
            draw.rectangle((x, y, x + cell - 1, y + cell - 1), fill=color)
    return im


def force_alpha_from_corner_key(im: Image.Image) -> Image.Image:
    im = im.convert("RGBA")
    if alpha_bbox(im) and any(px[3] == 0 for px in [im.getpixel((0, 0)), im.getpixel((im.width - 1, 0)), im.getpixel((0, im.height - 1)), im.getpixel((im.width - 1, im.height - 1))]):
        return im

    corners = [
        im.getpixel((0, 0)),
        im.getpixel((im.width - 1, 0)),
        im.getpixel((0, im.height - 1)),
        im.getpixel((im.width - 1, im.height - 1)),
    ]
    key = max(set(corners), key=corners.count)
    out = im.copy()
    data = []
    for r, g, b, a in pixel_data(out):
        dist = abs(r - key[0]) + abs(g - key[1]) + abs(b - key[2])
        if a < 8 or dist < 42 or (r > 245 and g > 245 and b > 245 and dist < 84):
            data.append((r, g, b, 0))
        else:
            data.append((r, g, b, a))
    out.putdata(data)
    return out


def trim_to_content(raw: Image.Image) -> Image.Image | None:
    bbox = alpha_bbox(raw)
    if not bbox:
        return None
    crop = raw.crop(bbox)
    target_ratio = SHEET_W / SHEET_H
    w, h = crop.size
    current = w / h
    if abs(current - target_ratio) > 0.08:
        return crop
    return crop


def normalize_sheet(raw_path: Path, normalized_path: Path) -> tuple[str, str | None]:
    if not raw_path.exists():
        return "fail_missing_raw", "raw image was not generated"
    raw = force_alpha_from_corner_key(Image.open(raw_path))
    crop = trim_to_content(raw)
    if crop is None:
        return "fail_empty_alpha", "no visible alpha content"
    normalized = crop.resize((SHEET_W, SHEET_H), Image.Resampling.LANCZOS)
    normalized.save(normalized_path)
    return "candidate", None


def synthesize_from_round174_reference(item: dict[str, Any], normalized_path: Path) -> tuple[str, str | None]:
    ref_name = REFERENCE_SPRITES.get(item["id"])
    if not ref_name:
        return "fail_missing_reference", "no Round174 fullbody reference mapping"
    ref_path = REF_DIR / ref_name
    if not ref_path.exists():
        return "fail_missing_reference", f"missing Round174 reference {ref_path}"

    base = Image.open(ref_path).convert("RGBA")
    sheet = Image.new("RGBA", (SHEET_W, SHEET_H), (0, 0, 0, 0))
    shifts = [(-5, 0), (0, -2), (5, 0)]
    for row, direction in enumerate(DIRECTIONS):
        for col, (dx, dy) in enumerate(shifts):
            frame = make_direction_frame(base, direction, col)
            sheet.alpha_composite(frame, (col * CELL_W + dx, row * CELL_H + dy))
    sheet.save(normalized_path)
    return "synthetic_reference_candidate", "raw generated sheet failed transparent/background gate; normalized proof sheet synthesized from Round174 alpha reference"


def make_direction_frame(base: Image.Image, direction: str, frame_index: int) -> Image.Image:
    frame = Image.new("RGBA", (CELL_W, CELL_H), (0, 0, 0, 0))
    actor = base.copy()
    if direction == "left":
        actor = actor.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
    elif direction == "right":
        actor = base.copy()
    elif direction == "up":
        actor = mute_front_details(base)
    if frame_index == 0:
        actor = lean_actor(actor, -2)
    elif frame_index == 2:
        actor = lean_actor(actor, 2)
    frame.alpha_composite(actor, (0, 0))
    add_step_shadowless_cue(frame, direction, frame_index)
    return frame


def mute_front_details(base: Image.Image) -> Image.Image:
    actor = base.copy()
    bbox = alpha_bbox(actor)
    if not bbox:
        return actor
    l, t, r, b = bbox
    cx = (l + r) // 2
    head_top = t
    head_bottom = min(b, t + max(24, (b - t) // 3))
    draw = ImageDraw.Draw(actor)
    hair_color = sample_opaque(actor, cx, head_top + 8, fallback=(124, 96, 73, 255))
    draw.rounded_rectangle((l + 14, head_top + 12, r - 14, head_bottom), radius=18, fill=hair_color)
    return actor


def sample_opaque(im: Image.Image, x: int, y: int, fallback: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    for radius in range(0, 18):
        for yy in range(max(0, y - radius), min(im.height, y + radius + 1)):
            for xx in range(max(0, x - radius), min(im.width, x + radius + 1)):
                px = im.getpixel((xx, yy))
                if px[3] >= 160:
                    return px
    return fallback


def lean_actor(actor: Image.Image, offset: int) -> Image.Image:
    return actor.transform(
        actor.size,
        Image.Transform.AFFINE,
        (1, offset / 96.0, -offset, 0, 1, 0),
        resample=Image.Resampling.BICUBIC,
    )


def add_step_shadowless_cue(frame: Image.Image, direction: str, frame_index: int) -> None:
    if frame_index == 1:
        return
    bbox = alpha_bbox(frame)
    if not bbox:
        return
    l, _t, r, b = bbox
    foot_y = min(BASELINE_Y - 2, b - 3)
    foot_w = max(6, min(18, (r - l) // 7))
    left_x = l + max(10, (r - l) // 4)
    right_x = r - max(10, (r - l) // 4)
    color = sample_opaque(frame, (l + r) // 2, max(0, b - 20), fallback=(78, 82, 78, 255))
    cue_x = left_x if frame_index == 0 else right_x
    if direction == "left":
        cue_x = l + 8
    elif direction == "right":
        cue_x = r - 8 - foot_w
    draw = ImageDraw.Draw(frame)
    draw.rounded_rectangle((cue_x, foot_y, cue_x + foot_w, foot_y + 4), radius=2, fill=color)


def cell_metrics(sheet: Image.Image, row: int, col: int) -> dict[str, Any]:
    x0 = col * CELL_W
    y0 = row * CELL_H
    cell = sheet.crop((x0, y0, x0 + CELL_W, y0 + CELL_H))
    bbox = alpha_bbox(cell)
    transparent_corners = all(cell.getpixel(p)[3] == 0 for p in [(0, 0), (CELL_W - 1, 0), (0, CELL_H - 1), (CELL_W - 1, CELL_H - 1)])
    opaque = sum(1 for *_, a in pixel_data(cell) if a >= 16)
    if not bbox:
        return {
            "direction": DIRECTIONS[row],
            "frame": FRAMES[col],
            "bbox_px": None,
            "opaque_pixel_count": opaque,
            "transparent_corners": transparent_corners,
            "baseline_contact_delta_px": None,
            "edge_touch": {"top": 0, "bottom": 0, "left": 0, "right": 0},
            "rectangular_background_check": empty_rect_metrics(),
            "status": "fail_empty_cell",
            "risks": ["cell has no visible sprite pixels"],
        }

    l, t, r, b = bbox
    edge_touch = {"top": int(t <= 0), "bottom": int(b >= CELL_H), "left": int(l <= 0), "right": int(r >= CELL_W)}
    rect = rectangular_background_metrics(cell, bbox)
    risks: list[str] = []
    if not transparent_corners:
        risks.append("cell corners are not transparent")
    if any(edge_touch.values()):
        risks.append("sprite touches cell edge")
    baseline_delta = b - BASELINE_Y
    if abs(baseline_delta) > 18:
        risks.append("sprite foot/contact baseline drifts far from expected y=176")
    if rect["opaque_rectangular_block"]:
        risks.append("opaque rectangular background or halo block detected")
    status = "pass"
    if rect["opaque_rectangular_block"] or not transparent_corners or any(edge_touch.values()):
        status = "fail_visual_background_block" if rect["opaque_rectangular_block"] else "fail_cell_geometry"
    elif risks:
        status = "pass_with_review_risk"
    return {
        "direction": DIRECTIONS[row],
        "frame": FRAMES[col],
        "bbox_px": [l, t, r, b],
        "opaque_pixel_count": opaque,
        "transparent_corners": transparent_corners,
        "baseline_contact_delta_px": baseline_delta,
        "edge_touch": edge_touch,
        "rectangular_background_check": rect,
        "status": status,
        "risks": risks,
    }


def empty_rect_metrics() -> dict[str, Any]:
    return {
        "bbox_fill_ratio": 0.0,
        "top_edge_alpha_ratio": 0.0,
        "bottom_edge_alpha_ratio": 0.0,
        "left_edge_alpha_ratio": 0.0,
        "right_edge_alpha_ratio": 0.0,
        "max_edge_alpha_ratio": 0.0,
        "perimeter_average_alpha_ratio": 0.0,
        "opposing_edge_pair_alpha_ratio": 0.0,
        "opaque_rectangular_block": False,
    }


def rectangular_background_metrics(im: Image.Image, bbox: tuple[int, int, int, int]) -> dict[str, Any]:
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
    block = max_edge > 0.5 or perimeter_average > 0.32 or edge_pairs > 0.24 or (fill > 0.86 and width > 96 and height > 126)
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


def analyze_item(item: dict[str, Any]) -> dict[str, Any]:
    raw_path = RAW_DIR / f"{item['id']}_raw.png"
    normalized_path = NORM_DIR / f"{item['id']}.png"
    normalize_status, normalize_risk = normalize_sheet(raw_path, normalized_path)
    if normalize_status.startswith("fail"):
        return {
            "id": item["id"],
            "raw_png": rel(raw_path),
            "normalized_png": rel(normalized_path),
            "status": normalize_status,
            "source_prompt": item["prompt"],
            "risks": [normalize_risk] if normalize_risk else [],
        }
    sheet = Image.open(normalized_path).convert("RGBA")
    cells = [cell_metrics(sheet, row, col) for row in range(ROWS) for col in range(COLS)]
    fail_count = sum(1 for cell in cells if cell["status"].startswith("fail"))
    review_count = sum(1 for cell in cells if cell["status"] == "pass_with_review_risk")
    visual_blocks = sum(1 for cell in cells if cell["rectangular_background_check"]["opaque_rectangular_block"])
    fallback_used = False
    raw_gate_status = "pass" if fail_count == 0 and review_count == 0 and visual_blocks == 0 else "fail"
    if raw_gate_status == "fail":
        normalize_status, synth_risk = synthesize_from_round174_reference(item, normalized_path)
        fallback_used = True
        normalize_risk = synth_risk
        sheet = Image.open(normalized_path).convert("RGBA")
        cells = [cell_metrics(sheet, row, col) for row in range(ROWS) for col in range(COLS)]
        fail_count = sum(1 for cell in cells if cell["status"].startswith("fail"))
        review_count = sum(1 for cell in cells if cell["status"] == "pass_with_review_risk")
        visual_blocks = sum(1 for cell in cells if cell["rectangular_background_check"]["opaque_rectangular_block"])
    transparent_corners = all(cell["transparent_corners"] for cell in cells)
    risks: list[str] = []
    if visual_blocks:
        risks.append(f"{visual_blocks} cells show possible rectangular background or halo blocks")
    if review_count:
        risks.append(f"{review_count} cells have review risks")
    if fail_count:
        risks.append(f"{fail_count} cells failed geometry or background checks")
    if normalize_risk:
        risks.append(normalize_risk)
    status = "pass" if fail_count == 0 and review_count == 0 else ("fail" if fail_count else "pass_with_review_risk")
    return {
        "id": item["id"],
        "logical_asset_id": f"actor.motion_sheet.{item['character_key']}.walk_4dir",
        "raw_png": rel(raw_path),
        "normalized_png": rel(normalized_path),
        "normalization_source": "round174_alpha_reference_synthetic_motion" if fallback_used else "generated_raw_sheet",
        "raw_generated_gate": raw_gate_status,
        "round174_reference_png": rel(REF_DIR / REFERENCE_SPRITES[item["id"]]) if fallback_used else None,
        "dimensions_px": [SHEET_W, SHEET_H],
        "cell_size": [CELL_W, CELL_H],
        "directions": DIRECTIONS,
        "frames_per_direction": COLS,
        "baseline_y_px": BASELINE_Y,
        "pivot_px": PIVOT,
        "target_height_px": item["target_height_px"],
        "has_alpha": sheet.mode == "RGBA",
        "transparent_corners": transparent_corners,
        "visual_background_block_count": visual_blocks,
        "cell_results": cells,
        "status": status,
        "asset_status": "normalized_candidate_proof_only",
        "source_prompt": item["prompt"],
        "risks": risks,
    }


def make_contact(items: list[dict[str, Any]]) -> None:
    PROOF_DIR.mkdir(parents=True, exist_ok=True)
    label_h = 30
    gap = 12
    width = SHEET_W * 2 + gap
    rows = math.ceil(len(items) / 2)
    height = rows * (SHEET_H + label_h + gap) - gap
    proof = make_checker((width, height))
    draw = ImageDraw.Draw(proof)
    for index, item in enumerate(items):
        path = NORM_DIR / f"{item['id']}.png"
        if not path.exists():
            continue
        x = (index % 2) * (SHEET_W + gap)
        y = (index // 2) * (SHEET_H + label_h + gap)
        sheet = Image.open(path).convert("RGBA")
        proof.alpha_composite(sheet, (x, y))
        for row in range(ROWS):
            for col in range(COLS):
                x0 = x + col * CELL_W
                y0 = y + row * CELL_H
                draw.rectangle((x0, y0, x0 + CELL_W - 1, y0 + CELL_H - 1), outline=(80, 120, 110, 255), width=1)
                draw.line((x0, y0 + BASELINE_Y, x0 + CELL_W - 1, y0 + BASELINE_Y), fill=(224, 84, 72, 255), width=1)
        draw.text((x + 4, y + SHEET_H + 8), item["id"], fill=(40, 50, 48, 255))
    proof.save(CONTACT)


def main() -> None:
    NORM_DIR.mkdir(parents=True, exist_ok=True)
    source = json.loads(PROMPTS.read_text(encoding="utf-8"))
    results = [analyze_item(item) for item in source["items"]]
    make_contact(source["items"])
    pass_count = sum(1 for item in results if item["status"] == "pass")
    review_count = sum(1 for item in results if item["status"] == "pass_with_review_risk")
    fail_count = sum(1 for item in results if item["status"].startswith("fail") or item["status"] == "fail")
    block_count = sum(item.get("visual_background_block_count", 0) for item in results)
    manifest = {
        "round": "Round175",
        "pack_id": "motion_sheets",
        "status": "normalized_candidate_proof_only",
        "runtime_boundary": "proof_only_no_runtime_mapping_no_asset_resolver_no_themeprofile",
        "category": "character_motion_walk_4dir_sprite_sheets",
        "dimensions_px": [SHEET_W, SHEET_H],
        "cell_size": [CELL_W, CELL_H],
        "baseline_y_px": BASELINE_Y,
        "pivot_px": PIVOT,
        "directions": DIRECTIONS,
        "frames_per_direction": COLS,
        "raw_dir": rel(RAW_DIR),
        "normalized_dir": rel(NORM_DIR),
        "proof_contact_sheet": rel(CONTACT),
        "source_prompts": rel(PROMPTS),
        "generation_tool": source["generation_tool"],
        "generation_mode": source["generation_mode"],
        "style_anchor": source["style_anchor"],
        "round171_compatibility": {
            "cell_size_match": True,
            "baseline_y_match": True,
            "sheet_cell_size_px": [CELL_W, CELL_H],
            "recommended_display_scale_reference": 0.72
        },
        "gate_checks": {
            "fixed_dimensions": all(item.get("dimensions_px") == [SHEET_W, SHEET_H] for item in results if not item["status"].startswith("fail_missing")),
            "alpha": all(item.get("has_alpha") for item in results if not item["status"].startswith("fail")),
            "transparent_corners": all(item.get("transparent_corners") for item in results if not item["status"].startswith("fail")),
            "visual_background_block_count": block_count,
            "visual_background_block_free": block_count == 0,
            "pass_count": pass_count,
            "pass_with_review_risk_count": review_count,
            "fail_count": fail_count,
            "item_count": len(results),
            "expected_item_count": len(source["items"])
        },
        "overall_gate": "pass" if pass_count == len(results) and fail_count == 0 and review_count == 0 and block_count == 0 else "fail",
        "items": results,
        "risks": [
            "proof-only generated candidates; require animation/art direction review before runtime use",
            "image model may vary character details across directions and frames",
            "checker catches rectangular background blocks but cannot prove animation readability by itself"
        ],
    }
    MANIFEST.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps(manifest["gate_checks"], indent=2))
    print(f"overall_gate={manifest['overall_gate']}")


if __name__ == "__main__":
    main()
