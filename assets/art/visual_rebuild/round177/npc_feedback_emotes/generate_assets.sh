#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GEN="/home/xionglei/GameProject/tools/image_generator.js"
RAW="$ROOT/raw"
mkdir -p "$RAW"

make_raw() {
  local slug="$1"
  local prompt="$2"
  node "$GEN" text "$prompt" "$RAW/${slug}_raw.png" "1024x1024" --transparent
}

COMMON="single overhead NPC feedback emote bubble for a cozy mobile town RPG, Apple-like translucent glass softness, child-friendly rounded icon inside a soft speech/thought bubble, centered with generous padding, transparent outside requested, no readable text, no letters, no numbers, no punctuation marks, no UI label, no watermark, no characters, no full scene"

make_raw "friendly_hello_bubble" "$COMMON, friendly hello feeling shown by a tiny open hand wave icon made of simple rounded shapes, warm peach and sky highlights"
make_raw "gentle_need_help_bubble" "$COMMON, gentle need-help feeling shown by two soft helping hands and a small glow dot, no question mark or exclamation mark"
make_raw "gift_thought_bubble" "$COMMON, gift thought shown by a small wrapped gift box with ribbon loops only, no labels"
make_raw "sunny_happy_bubble" "$COMMON, sunny happy mood shown by a smiling sun-like circle with rounded rays, no face text"
make_raw "sleepy_soft_bubble" "$COMMON, sleepy soft mood shown by a crescent moon and soft floating dots only, no Z letters"
make_raw "hungry_snack_bubble" "$COMMON, hungry snack thought shown by a small snack bowl and tiny fruit shapes, no labels"
make_raw "friendship_heart_bubble" "$COMMON, friendship feeling shown by two overlapping soft heart shapes with a gentle glow"
make_raw "weather_umbrella_bubble" "$COMMON, weather/rain thought shown by a small rounded umbrella and two soft raindrops"
make_raw "found_item_spark_bubble" "$COMMON, found item feeling shown by a tiny leaf-shaped token with abstract sparkles, no star punctuation"
make_raw "calm_question_bubble" "$COMMON, calm curiosity feeling shown by a soft spiral and three small dots, no question mark"
