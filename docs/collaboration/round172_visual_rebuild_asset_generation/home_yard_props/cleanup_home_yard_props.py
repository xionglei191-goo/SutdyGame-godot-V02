#!/usr/bin/env python3
"""Remove tiny cross-cell spill fragments from Round172 normalized props."""

from __future__ import annotations

from pathlib import Path

from PIL import Image


ROOT = Path("assets/art/visual_rebuild/round172/home_yard_props/normalized_128x128")
ITEM_CLEANUP = {
    "home_yard_prop_03_128x128.png": 96,
    "home_yard_prop_07_128x128.png": 112,
}


def clear_right_band(path: Path, start_x: int) -> None:
    image = Image.open(path).convert("RGBA")
    pixels = image.load()
    width, height = image.size
    for y in range(height):
        for x in range(start_x, width):
            pixels[x, y] = (0, 0, 0, 0)
    image.save(path)


def main() -> None:
    for filename, start_x in ITEM_CLEANUP.items():
        clear_right_band(ROOT / filename, start_x)


if __name__ == "__main__":
    main()
