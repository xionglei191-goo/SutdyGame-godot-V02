#!/usr/bin/env python3
from __future__ import annotations

import json
import subprocess
import time
from pathlib import Path


ROOT = Path(__file__).resolve().parent
PROMPTS = ROOT / "source_prompts.json"
RAW_DIR = ROOT / "raw_generated"


def main() -> None:
    source = json.loads(PROMPTS.read_text(encoding="utf-8"))
    generator = source["generation_tool"]
    RAW_DIR.mkdir(parents=True, exist_ok=True)
    for item in source["items"]:
        out = RAW_DIR / f"{item['id']}_raw.png"
        if out.exists():
            print(f"skip existing {out}")
            continue
        cmd = [
            "/usr/bin/env",
            "node",
            generator,
            "text",
            item["prompt"],
            str(out),
            "1024x1024",
            "--transparent",
        ]
        for attempt in range(1, 4):
            print(f"generate {item['id']} attempt {attempt}")
            result = subprocess.run(cmd, text=True)
            if result.returncode == 0:
                break
            if attempt == 3:
                raise SystemExit(result.returncode)
            time.sleep(20)


if __name__ == "__main__":
    main()
