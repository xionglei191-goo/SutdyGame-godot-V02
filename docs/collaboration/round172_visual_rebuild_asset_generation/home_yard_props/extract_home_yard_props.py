#!/usr/bin/env python3
"""Round172 local extraction helper for generated home yard props.

The generator produced a soft studio backdrop instead of true chroma/alpha.
This helper removes the continuous background per grid cell and composites the
remaining props over a flat #ff00ff chroma key source sheet.
"""

from __future__ import annotations

import argparse
from collections import deque
from pathlib import Path

from PIL import Image, ImageFilter


def color_delta(a: tuple[int, int, int], b: tuple[int, int, int]) -> int:
    return abs(a[0] - b[0]) + abs(a[1] - b[1]) + abs(a[2] - b[2])


def make_cell_mask(cell: Image.Image, step_threshold: int, edge_threshold: int) -> Image.Image:
    rgb = cell.convert("RGB")
    width, height = rgb.size
    pixels = rgb.load()
    background = [bytearray(width) for _ in range(height)]
    queue: deque[tuple[int, int]] = deque()

    corners = [
        pixels[0, 0],
        pixels[width - 1, 0],
        pixels[0, height - 1],
        pixels[width - 1, height - 1],
    ]

    def enqueue(x: int, y: int) -> None:
        if background[y][x]:
            return
        pixel = pixels[x, y]
        if min(color_delta(pixel, corner) for corner in corners) > edge_threshold:
            return
        background[y][x] = 1
        queue.append((x, y))

    for x in range(width):
        enqueue(x, 0)
        enqueue(x, height - 1)
    for y in range(height):
        enqueue(0, y)
        enqueue(width - 1, y)

    while queue:
        x, y = queue.popleft()
        current = pixels[x, y]
        for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
            if not (0 <= nx < width and 0 <= ny < height) or background[ny][nx]:
                continue
            candidate = pixels[nx, ny]
            if color_delta(candidate, current) <= step_threshold:
                background[ny][nx] = 1
                queue.append((nx, ny))

    alpha = Image.new("L", (width, height), 255)
    alpha_pixels = alpha.load()
    for y in range(height):
        for x in range(width):
            if background[y][x]:
                alpha_pixels[x, y] = 0

    return alpha.filter(ImageFilter.MinFilter(3)).filter(ImageFilter.GaussianBlur(0.45))


def extract_sheet(args: argparse.Namespace) -> None:
    source = Image.open(args.source).convert("RGBA")
    source_width, source_height = source.size
    cell_width = source_width // args.columns
    cell_height = source_height // args.rows

    alpha_sheet = Image.new("RGBA", source.size, (0, 0, 0, 0))
    chroma_sheet = Image.new("RGBA", source.size, args.key_color)

    for row in range(args.rows):
        for column in range(args.columns):
            x0 = column * cell_width
            y0 = row * cell_height
            x1 = (column + 1) * cell_width if column < args.columns - 1 else source_width
            y1 = (row + 1) * cell_height if row < args.rows - 1 else source_height
            cell = source.crop((x0, y0, x1, y1))
            mask = make_cell_mask(cell, args.step_threshold, args.edge_threshold)
            cell.putalpha(mask)
            alpha_sheet.alpha_composite(cell, (x0, y0))
            chroma_sheet.alpha_composite(cell, (x0, y0))

    args.alpha_output.parent.mkdir(parents=True, exist_ok=True)
    args.chroma_output.parent.mkdir(parents=True, exist_ok=True)
    alpha_sheet.save(args.alpha_output)
    chroma_sheet.convert("RGB").save(args.chroma_output)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("--alpha-output", type=Path, required=True)
    parser.add_argument("--chroma-output", type=Path, required=True)
    parser.add_argument("--columns", type=int, default=4)
    parser.add_argument("--rows", type=int, default=2)
    parser.add_argument("--step-threshold", type=int, default=22)
    parser.add_argument("--edge-threshold", type=int, default=210)
    parser.add_argument("--key-color", default=(255, 0, 255, 255))
    return parser.parse_args()


if __name__ == "__main__":
    extract_sheet(parse_args())
