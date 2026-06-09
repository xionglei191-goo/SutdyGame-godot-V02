#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPTS="$ROOT/source_prompts.json"
GENERATOR="/home/xionglei/GameProject/tools/image_generator.js"

python3 - "$PROMPTS" "$ROOT" "$GENERATOR" <<'PY'
import json
import shlex
import subprocess
import sys
from pathlib import Path

prompts_path = Path(sys.argv[1])
root = Path(sys.argv[2])
generator = Path(sys.argv[3])
data = json.loads(prompts_path.read_text(encoding="utf-8"))
raw_dir = root / "raw"
raw_dir.mkdir(parents=True, exist_ok=True)

for item in data["items"]:
    out = raw_dir / f"{item['id']}_raw.png"
    prompt = item["prompt"] + " Render only the single asset, isolated, centered, professional mobile game UI polish."
    cmd = ["node", str(generator), "text", prompt, str(out), "1024x1024", "--transparent"]
    print("RUN", " ".join(shlex.quote(part) for part in cmd), flush=True)
    subprocess.run(cmd, check=True)
PY
