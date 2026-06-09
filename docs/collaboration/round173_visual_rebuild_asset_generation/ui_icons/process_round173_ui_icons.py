from __future__ import annotations

import json
from collections import deque
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont


ROOT = Path(__file__).resolve().parents[4]
DOC_DIR = ROOT / "docs/collaboration/round173_visual_rebuild_asset_generation/ui_icons"
ASSET_DIR = ROOT / "assets/art/visual_rebuild/round173/ui_icons"
RAW_PATH = DOC_DIR / "round173_ui_icons_raw_sheet_chromakey_magenta.png"
KEY = (255, 0, 255)
CELL = 128
PADDING = 12

ICONS = [
    ("coin", "ui_icon.coin"),
    ("bag", "ui_icon.bag"),
    ("album", "ui_icon.album"),
    ("shop", "ui_icon.shop"),
    ("home", "ui_icon.home"),
    ("settings", "ui_icon.settings"),
    ("pet_status_heart", "ui_icon.pet_happy"),
    ("close_x", "ui_icon.close"),
    ("check_confirm", "ui_icon.confirm"),
    ("map_pin", "ui_icon.map_pin"),
]


def key_distance(pixel: tuple[int, int, int]) -> int:
    return abs(pixel[0] - KEY[0]) + abs(pixel[1] - KEY[1]) + abs(pixel[2] - KEY[2])


def make_alpha_sheet(raw: Image.Image) -> Image.Image:
    rgb = raw.convert("RGB")
    out = Image.new("RGBA", rgb.size, (0, 0, 0, 0))
    src = rgb.load()
    dst = out.load()
    w, h = rgb.size
    for y in range(h):
        for x in range(w):
            r, g, b = src[x, y]
            d = key_distance((r, g, b))
            if d <= 42:
                continue
            if d < 150:
                alpha = int(max(0, min(255, (d - 42) / 108 * 255)))
            else:
                alpha = 255
            # Despill magenta from antialias pixels without changing warm icon tones too much.
            if alpha < 255:
                m = min(r, b)
                spill = max(0, m - g)
                r = max(0, r - int(spill * 0.65))
                b = max(0, b - int(spill * 0.65))
            dst[x, y] = (r, g, b, alpha)
    return out


def connected_components(alpha: Image.Image) -> list[tuple[int, int, int, int, int]]:
    mask = alpha.getchannel("A").point(lambda a: 255 if a > 24 else 0)
    px = mask.load()
    w, h = mask.size
    seen: set[tuple[int, int]] = set()
    comps: list[tuple[int, int, int, int, int]] = []
    for y in range(h):
        for x in range(w):
            if px[x, y] == 0 or (x, y) in seen:
                continue
            q: deque[tuple[int, int]] = deque([(x, y)])
            seen.add((x, y))
            min_x = max_x = x
            min_y = max_y = y
            count = 0
            while q:
                cx, cy = q.popleft()
                count += 1
                min_x = min(min_x, cx)
                max_x = max(max_x, cx)
                min_y = min(min_y, cy)
                max_y = max(max_y, cy)
                for nx in (cx - 1, cx, cx + 1):
                    for ny in (cy - 1, cy, cy + 1):
                        if nx < 0 or ny < 0 or nx >= w or ny >= h:
                            continue
                        if (nx, ny) in seen or px[nx, ny] == 0:
                            continue
                        seen.add((nx, ny))
                        q.append((nx, ny))
            if count > 900:
                comps.append((min_x, min_y, max_x + 1, max_y + 1, count))
    return sorted(comps, key=lambda b: (b[1] // 300, b[0]))[: len(ICONS)]


def normalize_icon(sheet: Image.Image, bbox: tuple[int, int, int, int, int]) -> tuple[Image.Image, tuple[int, int, int, int]]:
    x0, y0, x1, y1, _ = bbox
    crop = sheet.crop((x0, y0, x1, y1))
    max_side = CELL - PADDING * 2
    scale = min(max_side / crop.width, max_side / crop.height)
    new_size = (max(1, round(crop.width * scale)), max(1, round(crop.height * scale)))
    crop = crop.resize(new_size, Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (CELL, CELL), (0, 0, 0, 0))
    ox = (CELL - new_size[0]) // 2
    oy = (CELL - new_size[1]) // 2
    canvas.alpha_composite(crop, (ox, oy))
    repair_visible_key(canvas)
    return canvas, (ox, oy, ox + new_size[0], oy + new_size[1])


def repair_visible_key(img: Image.Image) -> None:
    px = img.load()
    w, h = img.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a == 0:
                continue
            if abs(r - KEY[0]) <= 18 and g <= 32 and abs(b - KEY[2]) <= 18:
                px[x, y] = (0, 0, 0, 0)
            elif a < 245 and r >= 170 and b >= 170 and g <= 155:
                px[x, y] = (0, 0, 0, 0)
            elif a < 255 and r > b and b >= 120 and g <= 150:
                px[x, y] = (max(0, r - 34), min(255, g + 10), max(0, b - 60), a)


def count_visible_key_pixels(img: Image.Image) -> int:
    rgba = img.convert("RGBA")
    count = 0
    for r, g, b, a in rgba.getdata():
        if a > 0 and abs(r - KEY[0]) <= 8 and abs(g - KEY[1]) <= 8 and abs(b - KEY[2]) <= 8:
            count += 1
    return count


def count_alpha_pixels(img: Image.Image) -> int:
    return sum(1 for a in img.convert("RGBA").getchannel("A").getdata() if a > 0)


def has_bbox(norm_bbox: tuple[int, int, int, int]) -> bool:
    x0, y0, x1, y1 = norm_bbox
    return x1 > x0 and y1 > y0


def make_atlas(icons: list[Image.Image]) -> Image.Image:
    atlas = Image.new("RGBA", (CELL * 5, CELL * 2), (0, 0, 0, 0))
    for i, img in enumerate(icons):
        atlas.alpha_composite(img, ((i % 5) * CELL, (i // 5) * CELL))
    return atlas


def make_proof(atlas: Image.Image, rows: list[dict]) -> Image.Image:
    proof = Image.new("RGBA", (1280, 720), (238, 246, 241, 255))
    draw = ImageDraw.Draw(proof)
    for y in range(720):
        blend = y / 719
        r = int(230 * (1 - blend) + 190 * blend)
        g = int(246 * (1 - blend) + 228 * blend)
        b = int(240 * (1 - blend) + 248 * blend)
        draw.line((0, y, 1280, y), fill=(r, g, b, 255))
    panel = Image.new("RGBA", (820, 430), (255, 255, 255, 92))
    panel = panel.filter(ImageFilter.GaussianBlur(0.2))
    proof.alpha_composite(panel, (230, 110))
    draw.rounded_rectangle((230, 110, 1050, 540), radius=28, outline=(255, 255, 255, 160), width=2)
    scaled = atlas.resize((CELL * 5, CELL * 2), Image.Resampling.NEAREST)
    proof.alpha_composite(scaled, (320, 188))
    font = ImageFont.load_default()
    draw.text((244, 126), "Round173 UI icon candidates - fixed 128x128 transparent cells", fill=(40, 56, 64, 255), font=font)
    for i, row in enumerate(rows):
        cx = 320 + (i % 5) * CELL + 8
        cy = 188 + (i // 5) * CELL + CELL + 8
        draw.text((cx, cy), row["icon_id"], fill=(40, 56, 64, 255), font=font)
    draw.text((244, 568), "Proof background intentionally non-white to expose alpha/key residue. Runtime mapping intentionally not included.", fill=(40, 56, 64, 255), font=font)
    return proof


def main() -> None:
    ASSET_DIR.mkdir(parents=True, exist_ok=True)
    raw = Image.open(RAW_PATH)
    alpha_sheet = make_alpha_sheet(raw)
    alpha_sheet_path = DOC_DIR / "round173_ui_icons_alpha_sheet_debug.png"
    alpha_sheet.save(alpha_sheet_path)
    comps = connected_components(alpha_sheet)
    if len(comps) != len(ICONS):
        raise RuntimeError(f"Expected {len(ICONS)} components, found {len(comps)}: {comps}")

    normalized: list[Image.Image] = []
    rows: list[dict] = []
    for (icon_id, logical_id), bbox in zip(ICONS, comps):
        icon, norm_bbox = normalize_icon(alpha_sheet, bbox)
        out_path = ASSET_DIR / f"round173_ui_icon_{icon_id}_128.png"
        icon.save(out_path)
        alpha_pixels = count_alpha_pixels(icon)
        key_pixels = count_visible_key_pixels(icon)
        row = {
            "icon_id": icon_id,
            "logical_asset_id_candidate": logical_id,
            "category": "ui_icon",
            "normalized_png": str(out_path.relative_to(ROOT)),
            "cell_px": [CELL, CELL],
            "raw_bbox_px": list(bbox[:4]),
            "normalized_bbox_px": list(norm_bbox),
            "alpha_pixels": alpha_pixels,
            "visible_key_pixels": key_pixels,
            "has_alpha": icon.mode == "RGBA",
            "has_bbox": has_bbox(norm_bbox) and alpha_pixels > 0,
            "gate": "pass" if icon.mode == "RGBA" and has_bbox(norm_bbox) and alpha_pixels > 0 and key_pixels == 0 else "fail",
        }
        rows.append(row)
        normalized.append(icon)

    atlas = make_atlas(normalized)
    atlas_path = ASSET_DIR / "round173_ui_icons_atlas_5x2_128.png"
    atlas.save(atlas_path)
    proof = make_proof(atlas, rows)
    proof_path = ASSET_DIR / "round173_ui_icons_proof_1280x720.png"
    proof.save(proof_path)

    overall_gate = "pass"
    if atlas.size != (CELL * 5, CELL * 2):
        overall_gate = "fail"
    if count_visible_key_pixels(atlas) != 0:
        overall_gate = "fail"
    if any(row["gate"] != "pass" for row in rows):
        overall_gate = "fail"

    manifest = {
        "round": "Round173",
        "pack_id": "round173_proof_only_ui_icons_status_icons",
        "category": "ui_icon",
        "runtime_boundary": "candidate_only_no_asset_resolver_or_themeprofile_mapping",
        "source_raw": str(RAW_PATH.relative_to(ROOT)),
        "source_alpha_debug": str(alpha_sheet_path.relative_to(ROOT)),
        "atlas": str(atlas_path.relative_to(ROOT)),
        "proof": str(proof_path.relative_to(ROOT)),
        "cell_px": [CELL, CELL],
        "atlas_grid": [5, 2],
        "icons": rows,
        "validation": {
            "fixed_cell_atlas": atlas.size == (CELL * 5, CELL * 2),
            "atlas_has_alpha": atlas.mode == "RGBA",
            "all_icons_have_bbox": all(row["has_bbox"] for row in rows),
            "visible_key_pixels": count_visible_key_pixels(atlas),
            "overall_gate": overall_gate,
        },
        "risks": {
            "glass_ui_alpha_risk": "medium: chroma-key removal preserves opaque icon candidates, but glossy translucent highlights still need review on real Apple-like glass buttons before runtime mapping.",
            "candidate_semantics_risk": "confirm and map_pin are not yet listed as docs/10 P0/P1 runtime IDs; keep as proof-only candidates until UI contract decides stable logical IDs.",
        },
    }
    manifest_path = ASSET_DIR / "round173_ui_icons_manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps(manifest["validation"], indent=2))
    print(manifest_path.relative_to(ROOT))


if __name__ == "__main__":
    main()
