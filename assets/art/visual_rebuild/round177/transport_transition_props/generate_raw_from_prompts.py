#!/usr/bin/env python3
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parent
RAW = ROOT / "raw"
GENERATOR = Path("/home/xionglei/GameProject/tools/image_generator.js")


ITEMS = [
    {
        "slug": "small_bus_side",
        "prompt": "single cozy town transport prop only: small rounded community bus side view, warm cream and soft teal paint, cute toy-like proportions, 3/4 prefab game asset style with slight top visibility, blank windows, no driver, no passengers, no readable text, no letters, no numbers, no route marks, no symbols, no logos, no brand, no full scene, no road, no background objects, centered with generous padding, transparent background requested, child-friendly Animal Crossing-like cozy town style",
    },
    {
        "slug": "tiny_taxi_marker_blank",
        "prompt": "single cozy town transport marker prop only: tiny taxi waiting marker sign on a short rounded post with a blank smooth face, small soft base, warm yellow accent, 3/4 prefab game asset style, no readable text, no letters, no numbers, no taxi word, no symbols, no logos, no brand, no full scene, no vehicles, centered with generous padding, transparent background requested, child-friendly Animal Crossing-like cozy town style",
    },
    {
        "slug": "bicycle_rack_empty",
        "prompt": "single cozy town street prop only: empty bicycle rack made of rounded pale wood and soft metal loops, compact 3/4 prefab game asset, no bicycles, no readable text, no letters, no numbers, no symbols, no logos, no brand, no full scene, no pavement tile sheet, centered with generous padding, transparent background requested, child-friendly Animal Crossing-like cozy town style",
    },
    {
        "slug": "wooden_bridge_short",
        "prompt": "single cozy town transition prop only: short low wooden footbridge segment for crossing a narrow stream, rounded planks and simple side rails, 3/4 prefab game asset with warm wood, no readable text, no letters, no numbers, no symbols, no logos, no full scene, no water background, no grass background, centered with generous padding, transparent background requested, compatible with soft path and water tiles, child-friendly Animal Crossing-like cozy town style",
    },
    {
        "slug": "stepping_stone_curve",
        "prompt": "single cozy town transition prop only: curved set of five rounded stepping stones, soft gray and mossy edges, 3/4 prefab game asset, no readable text, no letters, no numbers, no symbols, no logos, no full scene, no water background, no path background, centered with generous padding, transparent background requested, compatible with soft path and water tiles, child-friendly Animal Crossing-like cozy town style",
    },
    {
        "slug": "path_signpost_blank",
        "prompt": "single cozy town wayfinding prop only: small wooden path signpost with two blank arrow boards, rounded handcrafted wood, tiny leaf detail that is not a symbol, 3/4 prefab game asset, sign faces completely blank, no readable text, no letters, no numbers, no icons, no symbols, no logos, no brand, no full scene, centered with generous padding, transparent background requested, child-friendly Animal Crossing-like cozy town style",
    },
    {
        "slug": "garden_gate_open",
        "prompt": "single cozy town transition prop only: open garden gate with two short rounded fence posts and open hinged panels, pale painted wood with gentle flower-free greenery at base, 3/4 prefab game asset, clear walk-through opening, no readable text, no letters, no numbers, no symbols, no logos, no full scene, no path background, centered with generous padding, transparent background requested, child-friendly Animal Crossing-like cozy town style",
    },
    {
        "slug": "school_crosswalk_soft",
        "prompt": "single cozy town ground transition prop only: soft rounded school-area crosswalk prefab made of several pale cream stripe blocks on transparent background, slightly curved 3/4 top-down view, no readable text, no letters, no numbers, no traffic symbols, no logos, no brand, no full road scene, no asphalt rectangle background, centered with generous padding, transparent background requested, compatible with Round170 path tiles, child-friendly Animal Crossing-like cozy town style",
    },
    {
        "slug": "plaza_archway_small",
        "prompt": "single cozy town transition prop only: small plaza archway with rounded wooden posts and a blank curved top beam, warm wood and pastel trim, clear walk-through opening, 3/4 prefab game asset, no readable text, no letters, no numbers, no symbols, no logos, no brand marks, no full scene, no plaza background, centered with generous padding, transparent background requested, child-friendly Animal Crossing-like cozy town style",
    },
    {
        "slug": "ferry_pier_stub",
        "prompt": "single cozy town waterfront transition prop only: tiny ferry pier stub with rounded wooden dock planks and two short posts, compact 3/4 prefab game asset, no boat, no water background, no readable text, no letters, no numbers, no symbols, no logos, no brand, no full scene, centered with generous padding, transparent background requested, compatible with Round170 water edges, child-friendly Animal Crossing-like cozy town style",
    },
]


def main() -> None:
    RAW.mkdir(parents=True, exist_ok=True)
    if not GENERATOR.exists():
        raise SystemExit(f"Missing generator: {GENERATOR}")

    for item in ITEMS:
        out = RAW / f"{item['slug']}_raw.png"
        if out.exists():
            print(f"skip existing {out}")
            continue
        cmd = [
            "node",
            str(GENERATOR),
            "text",
            item["prompt"],
            str(out),
            "1024x1024",
            "--transparent",
        ]
        print(f"generate {item['slug']}")
        subprocess.run(cmd, check=True)


if __name__ == "__main__":
    main()
