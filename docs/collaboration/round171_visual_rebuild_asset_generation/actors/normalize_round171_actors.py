#!/usr/bin/env python3
"""Normalize Round171 proof-only actor chroma sheet into fixed transparent cells."""

from __future__ import annotations

import json
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw


ROOT = Path(__file__).resolve().parents[4]
ASSET_DIR = ROOT / "assets/art/visual_rebuild/round171/actors"
DOC_DIR = ROOT / "docs/collaboration/round171_visual_rebuild_asset_generation/actors"
RAW = ASSET_DIR / "round171_actors_raw_chroma_sheet.png"

CELL_W = 160
CELL_H = 192
BASELINE_Y = 176

ACTORS = [
    {
        "id": "round171_actor_child_player",
        "label": "Child player",
        "source_range": (0.00, 0.3334),
        "fit": (92, 150),
        "recommended_display_scale": 0.72,
    },
    {
        "id": "round171_actor_friendly_resident",
        "label": "Friendly animal resident",
        "source_range": (0.3334, 0.6667),
        "fit": (110, 158),
        "recommended_display_scale": 0.72,
    },
    {
        "id": "round171_actor_sunny_like_pet",
        "label": "Sunny-like companion pet",
        "source_range": (0.6667, 1.00),
        "fit": (78, 96),
        "recommended_display_scale": 0.72,
    },
]


def color_distance_sq(a: tuple[int, int, int], b: tuple[int, int, int]) -> int:
    return sum((int(a[i]) - int(b[i])) ** 2 for i in range(3))


def estimate_background(rgb: Image.Image) -> tuple[int, int, int]:
    width, height = rgb.size
    points = [
        (8, 8),
        (width - 9, 8),
        (8, height - 9),
        (width - 9, height - 9),
        (width // 2, 8),
        (width // 2, height - 9),
    ]
    samples = [rgb.getpixel(point) for point in points]
    return tuple(sorted(channel)[len(channel) // 2] for channel in zip(*samples))


def chroma_to_alpha(rgb: Image.Image, bg: tuple[int, int, int], tolerance: int = 96) -> Image.Image:
    rgba = rgb.convert("RGBA")
    pixels = rgba.load()
    tol_sq = tolerance * tolerance
    for y in range(rgba.height):
        for x in range(rgba.width):
            r, g, b, a = pixels[x, y]
            if color_distance_sq((r, g, b), bg) <= tol_sq:
                pixels[x, y] = (r, g, b, 0)
    return rgba


def trim_alpha(image: Image.Image) -> tuple[Image.Image, tuple[int, int, int, int]]:
    alpha = image.getchannel("A")
    bbox = alpha.getbbox()
    if bbox is None:
        raise RuntimeError("No non-transparent sprite pixels found after chroma key.")
    return image.crop(bbox), bbox


def fit_actor(trimmed: Image.Image, fit_size: tuple[int, int]) -> tuple[Image.Image, float]:
    max_w, max_h = fit_size
    scale = min(max_w / trimmed.width, max_h / trimmed.height)
    target_size = (
        max(1, int(round(trimmed.width * scale))),
        max(1, int(round(trimmed.height * scale))),
    )
    return trimmed.resize(target_size, Image.Resampling.LANCZOS), scale


def checker(size: tuple[int, int], tile: int = 16) -> Image.Image:
    image = Image.new("RGBA", size, (238, 241, 238, 255))
    draw = ImageDraw.Draw(image)
    for y in range(0, size[1], tile):
        for x in range(0, size[0], tile):
            if (x // tile + y // tile) % 2:
                draw.rectangle((x, y, x + tile - 1, y + tile - 1), fill=(219, 225, 219, 255))
    return image


def main() -> None:
    if not RAW.exists():
        raise FileNotFoundError(RAW)

    ASSET_DIR.mkdir(parents=True, exist_ok=True)
    DOC_DIR.mkdir(parents=True, exist_ok=True)

    raw = Image.open(RAW).convert("RGB")
    bg = estimate_background(raw)

    atlas = Image.new("RGBA", (CELL_W * len(ACTORS), CELL_H), (0, 0, 0, 0))
    proof = checker((CELL_W * len(ACTORS), CELL_H))
    metrics: list[dict[str, object]] = []

    for index, actor in enumerate(ACTORS):
        x0 = int(raw.width * actor["source_range"][0])
        x1 = int(raw.width * actor["source_range"][1])
        source_crop = raw.crop((x0, 0, x1, raw.height))
        keyed = chroma_to_alpha(source_crop, bg)
        trimmed, source_bbox = trim_alpha(keyed)
        fitted, fit_scale = fit_actor(trimmed, actor["fit"])

        cell = Image.new("RGBA", (CELL_W, CELL_H), (0, 0, 0, 0))
        paste_x = (CELL_W - fitted.width) // 2
        paste_y = BASELINE_Y - fitted.height
        cell.alpha_composite(fitted, (paste_x, paste_y))

        individual_path = ASSET_DIR / f"{actor['id']}_160x192.png"
        cell.save(individual_path)
        atlas.alpha_composite(cell, (index * CELL_W, 0))
        proof.alpha_composite(cell, (index * CELL_W, 0))

        alpha_bbox = cell.getchannel("A").getbbox()
        alpha = cell.getchannel("A")
        if hasattr(alpha, "get_flattened_data"):
            alpha_values = alpha.get_flattened_data()
        else:
            alpha_values = alpha.getdata()
        nontransparent = sum(1 for value in alpha_values if value > 0)
        metrics.append(
            {
                "id": actor["id"],
                "label": actor["label"],
                "file": str(individual_path.relative_to(ROOT)),
                "cell_px": [CELL_W, CELL_H],
                "source_crop_px": [x0, 0, x1 - x0, raw.height],
                "source_bbox_px": list(source_bbox),
                "fit_target_px": list(actor["fit"]),
                "normalized_bbox_px": list(alpha_bbox) if alpha_bbox else None,
                "opaque_pixel_count": nontransparent,
                "fit_scale_from_trim": round(fit_scale, 4),
                "recommended_display_scale": actor["recommended_display_scale"],
                "recommended_display_size_px": [
                    round(CELL_W * actor["recommended_display_scale"], 1),
                    round(CELL_H * actor["recommended_display_scale"], 1),
                ],
                "baseline_y_px": BASELINE_Y,
            }
        )

    atlas_path = ASSET_DIR / "round171_actors_scale_reference_atlas_160x192x3.png"
    proof_path = ASSET_DIR / "round171_actors_scale_reference_proof_checker.png"
    manifest_path = DOC_DIR / "round171_actors_manifest.json"
    atlas.save(atlas_path)
    proof.save(proof_path)

    manifest = {
        "status": "normalized_candidate_proof_only",
        "raw_file": str(RAW.relative_to(ROOT)),
        "atlas_file": str(atlas_path.relative_to(ROOT)),
        "proof_checker_file": str(proof_path.relative_to(ROOT)),
        "background_key_rgb_estimate": list(bg),
        "cell_px": [CELL_W, CELL_H],
        "baseline_y_px": BASELINE_Y,
        "actors": metrics,
        "gate": {
            "fixed_cell_size": all(item["cell_px"] == [CELL_W, CELL_H] for item in metrics),
            "transparent_rgba": True,
            "atlas_dimensions_px": list(atlas.size),
            "raw_runtime_mapping": False,
            "proof_only": True,
        },
    }
    manifest_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(manifest["gate"], indent=2))


if __name__ == "__main__":
    main()
