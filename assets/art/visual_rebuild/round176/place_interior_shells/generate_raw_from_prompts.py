#!/usr/bin/env python3
import json
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parent
PROMPTS = ROOT / "source_prompts.json"
RAW = ROOT / "raw"
GENERATOR = Path("/home/xionglei/GameProject/tools/image_generator.js")


def main() -> None:
    data = json.loads(PROMPTS.read_text(encoding="utf-8"))
    RAW.mkdir(parents=True, exist_ok=True)
    for item in data["items"]:
        out = RAW / f"{item['id']}_raw.png"
        if out.exists():
            print(f"skip existing {out}")
            continue
        prompt = (
            f"{data['style']} {item['prompt']} "
            f"{data['global_negative']} "
            "Use a single centered asset composition with generous padding."
        )
        cmd = [
            "node",
            str(GENERATOR),
            "text",
            prompt,
            str(out),
            "1024x1024"
        ]
        print("generating", item["id"])
        subprocess.run(cmd, check=True, cwd=ROOT)


if __name__ == "__main__":
    main()
