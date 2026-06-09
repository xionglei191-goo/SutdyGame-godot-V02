#!/usr/bin/env python3
"""Generate proof-only A-M A-Z memory-story vignette overlay candidates."""

from __future__ import annotations

import json
import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path("assets/art/visual_rebuild/round179/az_story_vignettes_a_m")
WORLD_MAP = Path("data/maps/world_map.json")
SIZE = (256, 192)
RAW_KEY = (0, 255, 0, 255)
RUNTIME_BOUNDARY = "proof_only_no_runtime_mapping_no_themeprofile_no_assetresolver_no_data_changes"


STORY_SPECS = {
	"A": {
		"anchor_id": "anchor_a_apple",
		"core_word": "Apple",
		"palette": ["#e95f4e", "#ffd166", "#8ac46d", "#f7f0d2"],
		"story_hook": "A red apple waits on the home picnic cloth with a tiny trail of sparkles, so returning home recalls Apple before snack time.",
		"revisit_path_note": "From Home door, look beside the cozy picnic corner before visiting Sunny.",
	},
	"B": {
		"anchor_id": "anchor_b_bear",
		"core_word": "Bear",
		"palette": ["#b77b4b", "#f2c48d", "#78a8d8", "#f6e2b8"],
		"story_hook": "A friendly bear story cushion peeks from the Town Start bench, inviting a calm first hello.",
		"revisit_path_note": "Walk from Home toward Town Start and pause at the story bench.",
	},
	"C": {
		"anchor_id": "anchor_c_clock",
		"core_word": "Clock",
		"palette": ["#7fb8d8", "#f8e7a1", "#c8905d", "#f7f2df"],
		"story_hook": "A little clock on the home shelf points to cozy reading time, with a ribbon marking the next visit.",
		"revisit_path_note": "Inside the Home area, revisit the shelf before the daily routine.",
	},
	"D": {
		"anchor_id": "anchor_d_dog",
		"core_word": "Dog",
		"palette": ["#d99b68", "#f3d6a5", "#7fbf7f", "#f7f1dc"],
		"story_hook": "A small dog bowl and paw path near Home hint that a gentle dog friend has just trotted by.",
		"revisit_path_note": "Return to Home yard and follow the tiny paw prints near the pet corner.",
	},
	"E": {
		"anchor_id": "anchor_e_elephant",
		"core_word": "Elephant",
		"palette": ["#9eb3c7", "#f5cc6a", "#86b97a", "#f4e7c2"],
		"story_hook": "A soft elephant watering can sprinkles park flowers, making Elephant feel like a helpful garden memory.",
		"revisit_path_note": "Visit Animal Park and check the flower patch by the watering can.",
	},
	"F": {
		"anchor_id": "anchor_f_fox",
		"core_word": "Fox",
		"palette": ["#e58b45", "#fff0c6", "#87b5d6", "#f4dfb4"],
		"story_hook": "A fox-shaped kite tail curls around a park stump, leaving a playful clue for Fox.",
		"revisit_path_note": "In Animal Park, circle the stump on the quiet play path.",
	},
	"G": {
		"anchor_id": "anchor_g_gate",
		"core_word": "Gate",
		"palette": ["#8fbc8f", "#d8b46f", "#6fa3c7", "#f6efd5"],
		"story_hook": "The school gate has a welcoming ribbon and two warm lantern dots, turning Gate into a morning arrival memory.",
		"revisit_path_note": "Walk to School Gate and stop at the ribboned entrance.",
	},
	"H": {
		"anchor_id": "anchor_h_hat",
		"core_word": "Hat",
		"palette": ["#5fa8c8", "#f0b65a", "#e7878a", "#f7edcf"],
		"story_hook": "A cheerful hat rests on the supermarket display basket, ready for a pretend shopkeeper greeting.",
		"revisit_path_note": "At Supermarket, revisit the front basket before browsing.",
	},
	"I": {
		"anchor_id": "anchor_i_ice_cream",
		"core_word": "Ice cream",
		"palette": ["#f59abc", "#f7df91", "#8bd1d1", "#f7f0da"],
		"story_hook": "A tiny ice cream sign melts into three sweet drops near the shop counter, making Ice cream easy to spot.",
		"revisit_path_note": "Return to Supermarket and look beside the snack counter.",
	},
	"J": {
		"anchor_id": "anchor_j_jacket",
		"core_word": "Jacket",
		"palette": ["#6c9bd2", "#eac36a", "#c77b72", "#f4ebd0"],
		"story_hook": "A small jacket hangs from a warm shop peg with a stitched pocket star, waiting for a windy day.",
		"revisit_path_note": "At Supermarket, check the little clothing peg near the display wall.",
	},
	"K": {
		"anchor_id": "anchor_k_kite",
		"core_word": "Kite",
		"palette": ["#e66f5c", "#f7d65f", "#75b7d8", "#f5eac8"],
		"story_hook": "A bright kite loops over the school yard line, turning Kite into a breezy recess memory.",
		"revisit_path_note": "Walk into School Yard and look up along the open play path.",
	},
	"L": {
		"anchor_id": "anchor_l_lion",
		"core_word": "Lion",
		"palette": ["#d99b3d", "#f5d37a", "#8fbf7b", "#f5e5bd"],
		"story_hook": "A lion mane flower wreath sits by the park path, friendly and round like a sunny hello.",
		"revisit_path_note": "Visit Animal Park and find the mane-shaped flower wreath.",
	},
	"M": {
		"anchor_id": "anchor_m_monkey",
		"core_word": "Monkey",
		"palette": ["#a86f45", "#f0c790", "#75b87a", "#f3dfb6"],
		"story_hook": "A monkey snack pouch swings from a low branch, leaving a banana-shaped clue in the park.",
		"revisit_path_note": "In Animal Park, revisit the low branch near the gentle climb path.",
	},
}


def font(size: int, bold: bool = False) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
	candidates = [
		"/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf" if bold else "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
		"/usr/share/fonts/truetype/liberation2/LiberationSans-Bold.ttf" if bold else "/usr/share/fonts/truetype/liberation2/LiberationSans-Regular.ttf",
	]
	for candidate in candidates:
		path = Path(candidate)
		if path.exists():
			return ImageFont.truetype(str(path), size)
	return ImageFont.load_default()


def add_shadowed(draw: ImageDraw.ImageDraw, xy: tuple[int, int], text: str, fill: str, size: int, bold: bool = False) -> None:
	f = font(size, bold)
	x, y = xy
	draw.text((x + 1, y + 2), text, font=f, fill=(108, 84, 64, 90))
	draw.text((x, y), text, font=f, fill=fill)


def ellipse(draw: ImageDraw.ImageDraw, box: tuple[int, int, int, int], fill: str, outline: str = "#795f48", width: int = 3) -> None:
	draw.ellipse(box, fill=fill, outline=outline, width=width)


def rounded(draw: ImageDraw.ImageDraw, box: tuple[int, int, int, int], radius: int, fill: str, outline: str = "#795f48", width: int = 3) -> None:
	draw.rounded_rectangle(box, radius=radius, fill=fill, outline=outline, width=width)


def polygon(draw: ImageDraw.ImageDraw, points: list[tuple[int, int]], fill: str, outline: str = "#795f48", width: int = 3) -> None:
	draw.polygon(points, fill=fill)
	draw.line(points + [points[0]], fill=outline, width=width, joint="curve")


def draw_sparkles(draw: ImageDraw.ImageDraw, color: str = "#fff4aa") -> None:
	for cx, cy, r in [(58, 54, 5), (196, 56, 4), (205, 132, 5), (74, 144, 3)]:
		draw.line((cx - r, cy, cx + r, cy), fill=color, width=2)
		draw.line((cx, cy - r, cx, cy + r), fill=color, width=2)


def draw_icon(draw: ImageDraw.ImageDraw, letter: str, spec: dict) -> None:
	p0, p1, p2, p3 = spec["palette"]
	# Soft transparent vignette cloud, not a rectangular badge.
	ellipse(draw, (43, 72, 213, 166), p3, "#b3946e", 2)
	draw.arc((42, 74, 214, 168), 188, 352, fill=(255, 255, 255, 90), width=3)
	draw_sparkles(draw)
	if letter == "A":
		rounded(draw, (56, 112, 202, 150), 18, "#f7d98b", "#9a7558", 3)
		ellipse(draw, (91, 40, 159, 116), p0, "#8f5b44", 4)
		draw.pieslice((126, 30, 172, 72), 205, 330, fill=p2, outline="#658a50", width=3)
		draw.line((128, 44, 121, 31), fill="#6b4b35", width=5)
	elif letter == "B":
		ellipse(draw, (82, 48, 174, 130), p0, "#7b573f", 4)
		ellipse(draw, (70, 40, 103, 73), p0, "#7b573f", 3)
		ellipse(draw, (153, 40, 186, 73), p0, "#7b573f", 3)
		ellipse(draw, (105, 80, 151, 121), p1, "#7b573f", 3)
		ellipse(draw, (103, 75, 111, 83), "#4c3a2c")
		ellipse(draw, (145, 75, 153, 83), "#4c3a2c")
		draw.arc((112, 92, 144, 112), 20, 160, fill="#4c3a2c", width=3)
	elif letter == "C":
		ellipse(draw, (81, 42, 175, 136), "#f7f1db", "#856b52", 5)
		ellipse(draw, (93, 54, 163, 124), p0, "#c79f62", 3)
		draw.line((128, 88, 128, 63), fill="#5e4c3f", width=5)
		draw.line((128, 88, 148, 102), fill="#5e4c3f", width=5)
		draw.arc((88, 34, 168, 74), 200, 340, fill=p1, width=5)
	elif letter == "D":
		ellipse(draw, (82, 58, 174, 128), p1, "#7d5940", 4)
		ellipse(draw, (72, 51, 105, 95), p0, "#7d5940", 3)
		ellipse(draw, (151, 51, 184, 95), p0, "#7d5940", 3)
		ellipse(draw, (112, 82, 144, 112), "#fff0d0", "#7d5940", 2)
		ellipse(draw, (106, 76, 114, 84), "#4a3428")
		ellipse(draw, (142, 76, 150, 84), "#4a3428")
		rounded(draw, (94, 124, 162, 147), 12, "#dfeecb", "#71915e", 2)
		for px in [68, 184, 202]:
			ellipse(draw, (px, 130, px + 14, 144), p2, "#71915e", 2)
	elif letter == "E":
		ellipse(draw, (83, 55, 174, 130), p0, "#647487", 4)
		ellipse(draw, (62, 70, 105, 122), p0, "#647487", 3)
		ellipse(draw, (151, 70, 194, 122), p0, "#647487", 3)
		draw.arc((126, 86, 165, 149), 280, 88, fill="#647487", width=9)
		for x in [178, 190, 202]:
			draw.line((x, 130, x + 5, 144), fill=p1, width=3)
		ellipse(draw, (112, 81, 120, 89), "#354052")
	elif letter == "F":
		polygon(draw, [(126, 45), (178, 103), (126, 139), (78, 103)], p0)
		polygon(draw, [(126, 45), (126, 139), (78, 103)], "#fff0c7", "#7b563b", 2)
		draw.line((126, 139, 99, 162, 85, 146), fill=p2, width=5)
		draw.arc((81, 127, 121, 166), 5, 205, fill=p0, width=6)
	elif letter == "G":
		rounded(draw, (70, 54, 186, 138), 14, "#d6b36f", "#715942", 5)
		rounded(draw, (92, 80, 164, 139), 11, "#f7edd0", "#715942", 3)
		draw.line((70, 100, 186, 100), fill=p0, width=7)
		draw.polygon([(104, 58), (128, 74), (152, 58)], fill="#e36f6a")
		for x in [86, 170]:
			ellipse(draw, (x, 91, x + 11, 102), p1, "#715942", 1)
	elif letter == "H":
		ellipse(draw, (68, 102, 188, 135), p1, "#76543f", 4)
		rounded(draw, (91, 55, 165, 112), 22, p0, "#76543f", 4)
		draw.line((91, 95, 165, 95), fill=p2, width=7)
		ellipse(draw, (110, 84, 126, 100), "#f6df6b", "#76543f", 2)
	elif letter == "I":
		ellipse(draw, (80, 51, 122, 95), "#f59abc", "#7e6045", 3)
		ellipse(draw, (112, 45, 154, 91), "#f7df91", "#7e6045", 3)
		ellipse(draw, (137, 53, 179, 96), "#8bd1d1", "#7e6045", 3)
		polygon(draw, [(92, 92), (166, 92), (129, 154)], "#d69b58", "#7e6045", 4)
		for x, y in [(94, 111), (161, 118), (128, 139)]:
			ellipse(draw, (x, y, x + 9, y + 13), "#f6b1c9", "#7e6045", 1)
	elif letter == "J":
		rounded(draw, (84, 52, 172, 138), 20, p0, "#5c4b40", 4)
		draw.line((128, 58, 128, 137), fill="#f6e4b2", width=5)
		draw.line((92, 86, 164, 86), fill=p1, width=5)
		rounded(draw, (98, 96, 121, 122), 7, "#f1c073", "#5c4b40", 2)
		rounded(draw, (136, 96, 159, 122), 7, "#f1c073", "#5c4b40", 2)
	elif letter == "K":
		polygon(draw, [(128, 42), (180, 91), (128, 142), (76, 91)], p0)
		draw.line((128, 42, 128, 142), fill="#76543e", width=4)
		draw.line((76, 91, 180, 91), fill="#76543e", width=4)
		draw.line((128, 142, 109, 160, 94, 148), fill=p2, width=4)
		for x, y in [(102, 151), (86, 142)]:
			polygon(draw, [(x, y), (x + 9, y + 6), (x, y + 12), (x - 9, y + 6)], p1, "#76543e", 1)
	elif letter == "L":
		ellipse(draw, (73, 44, 183, 139), p1, "#8a653b", 4)
		for angle in range(0, 360, 30):
			cx = 128 + int(math.cos(math.radians(angle)) * 48)
			cy = 92 + int(math.sin(math.radians(angle)) * 41)
			ellipse(draw, (cx - 13, cy - 13, cx + 13, cy + 13), "#d8903b", "#8a653b", 2)
		ellipse(draw, (95, 65, 161, 125), "#f3d27c", "#8a653b", 3)
		ellipse(draw, (111, 86, 119, 94), "#4d3a2c")
		ellipse(draw, (138, 86, 146, 94), "#4d3a2c")
		draw.arc((113, 98, 143, 113), 15, 165, fill="#4d3a2c", width=3)
	elif letter == "M":
		draw.line((128, 48, 128, 139), fill="#7f5a38", width=8)
		draw.arc((81, 35, 175, 95), 180, 360, fill=p2, width=8)
		ellipse(draw, (82, 68, 174, 134), p0, "#6f4f38", 4)
		ellipse(draw, (102, 88, 154, 125), p1, "#6f4f38", 3)
		ellipse(draw, (104, 82, 112, 90), "#3f3025")
		ellipse(draw, (144, 82, 152, 90), "#3f3025")
		draw.arc((112, 99, 146, 116), 25, 155, fill="#3f3025", width=3)
		polygon(draw, [(190, 120), (208, 129), (190, 138), (178, 129)], "#f2ce62", "#7a5d39", 2)
	add_shadowed(draw, (205, 20), letter, "#7b6048", 20, True)


def draw_item(letter: str, spec: dict) -> Image.Image:
	img = Image.new("RGBA", SIZE, (0, 0, 0, 0))
	draw = ImageDraw.Draw(img, "RGBA")
	draw_icon(draw, letter, spec)
	return img


def alpha_bbox(img: Image.Image) -> list[int]:
	bbox = img.getchannel("A").getbbox()
	if bbox is None:
		return [0, 0, 0, 0]
	return list(bbox)


def validate_png(path: Path) -> dict:
	img = Image.open(path).convert("RGBA")
	w, h = img.size
	alpha = img.getchannel("A")
	pixels = img.load()
	nonzero = 0
	opaque = 0
	green_residue = 0
	magenta_residue = 0
	dark_pinhole = 0
	opaque_white = 0
	for y in range(h):
		for x in range(w):
			r, g, b, a = pixels[x, y]
			if a > 0:
				nonzero += 1
			if a >= 250:
				opaque += 1
			if a > 0 and g > 220 and r < 40 and b < 40:
				green_residue += 1
			if a > 0 and r > 220 and b > 220 and g < 80:
				magenta_residue += 1
			if a > 200 and r < 18 and g < 18 and b < 18:
				dark_pinhole += 1
			if a > 245 and r > 248 and g > 248 and b > 248:
				opaque_white += 1
	corners = [alpha.getpixel((0, 0)), alpha.getpixel((w - 1, 0)), alpha.getpixel((0, h - 1)), alpha.getpixel((w - 1, h - 1))]
	edge_ratios = {
		"top": sum(1 for x in range(w) if alpha.getpixel((x, 0)) > 0) / w,
		"bottom": sum(1 for x in range(w) if alpha.getpixel((x, h - 1)) > 0) / w,
		"left": sum(1 for y in range(h) if alpha.getpixel((0, y)) > 0) / h,
		"right": sum(1 for y in range(h) if alpha.getpixel((w - 1, y)) > 0) / h,
	}
	opaque_ratio = opaque / float(w * h)
	coverage = nonzero / float(w * h)
	bg_block_risk = opaque_ratio > 0.82 or any(value > 0.2 for value in edge_ratios.values())
	passed = (
		img.mode == "RGBA"
		and img.size == SIZE
		and nonzero > 1000
		and all(value == 0 for value in corners)
		and green_residue == 0
		and magenta_residue == 0
		and not bg_block_risk
	)
	return {
		"rgba_alpha": img.mode == "RGBA",
		"dimensions": [w, h],
		"alpha_bbox": alpha_bbox(img),
		"nonzero_alpha_pixels": nonzero,
		"visible_alpha_coverage": round(coverage, 5),
		"transparent_corners": all(value == 0 for value in corners),
		"corner_alpha": corners,
		"edge_alpha_ratios": {key: round(value, 5) for key, value in edge_ratios.items()},
		"residue_scan": {
			"green_chroma_residue_pixels": green_residue,
			"magenta_residue_pixels": magenta_residue,
			"opaque_white_residue_pixels": opaque_white,
			"dark_pinhole_pixels": dark_pinhole,
		},
		"background_block_check": {
			"opaque_pixel_ratio": round(opaque_ratio, 5),
			"large_background_block_risk": bg_block_risk,
		},
		"pass": passed,
		"normalization_mode": "local_rgba_alpha_safe_synthesis_with_raw_chroma_evidence",
	}


def load_a_m_anchors() -> dict[str, dict]:
	data = json.loads(WORLD_MAP.read_text(encoding="utf-8"))
	anchors = {}
	for anchor in data["memory_anchors"]:
		letter = anchor["letter"]
		if "A" <= letter <= "M":
			anchors[letter] = {
				"anchor_id": anchor["anchor_id"],
				"core_word": anchor["core_word"],
				"place_id": anchor.get("place_id", ""),
				"route_order": anchor.get("route_order"),
			}
	return anchors


def make_contact_sheet(items: list[dict]) -> Path:
	cols = 4
	cell_w = 286
	cell_h = 244
	rows = math.ceil(len(items) / cols)
	sheet = Image.new("RGBA", (cols * cell_w, rows * cell_h), (246, 240, 224, 255))
	draw = ImageDraw.Draw(sheet, "RGBA")
	for index, item in enumerate(items):
		x = (index % cols) * cell_w
		y = (index // cols) * cell_h
		draw.rounded_rectangle((x + 12, y + 12, x + cell_w - 12, y + cell_h - 12), radius=8, fill=(255, 252, 242, 255), outline=(188, 160, 120, 255), width=2)
		img = Image.open(item["main_ref"]).convert("RGBA")
		sheet.alpha_composite(img, (x + 15, y + 18))
		add_shadowed(draw, (x + 22, y + 210), f"{item['letter']}  {item['core_word']}", "#6d573f", 16, True)
		draw.text((x + 142, y + 212), item["anchor_id"], font=font(11), fill="#806950")
	out = ROOT / "proof" / "round179_az_story_vignettes_a_m_contact_sheet.png"
	out.parent.mkdir(parents=True, exist_ok=True)
	sheet.convert("RGBA").save(out)
	return out


def main() -> None:
	for subdir in ["normalized_256x192", "raw", "proof"]:
		(ROOT / subdir).mkdir(parents=True, exist_ok=True)
	anchors = load_a_m_anchors()
	items = []
	coverage_failures = []
	for letter in [chr(value) for value in range(ord("A"), ord("M") + 1)]:
		spec = STORY_SPECS[letter]
		anchor = anchors.get(letter)
		if anchor is None or anchor["anchor_id"] != spec["anchor_id"] or anchor["core_word"] != spec["core_word"]:
			coverage_failures.append(letter)
			continue
		slug = spec["anchor_id"]
		logical_id = f"az_story_vignette.{slug}"
		normalized = ROOT / "normalized_256x192" / f"{slug}.png"
		raw = ROOT / "raw" / f"{slug}_raw_chroma.png"
		img = draw_item(letter, spec)
		raw_img = Image.new("RGBA", SIZE, RAW_KEY)
		raw_img.alpha_composite(img)
		raw_img.save(raw)
		img.save(normalized)
		validation = validate_png(normalized)
		items.append({
			"id": logical_id,
			"letter": letter,
			"anchor_id": spec["anchor_id"],
			"core_word": spec["core_word"],
			"place_id": anchor["place_id"],
			"route_order": anchor["route_order"],
			"status": "pass" if validation["pass"] else "fail",
			"asset_status": "proof_only_transparent_candidate",
			"main_ref": str(normalized),
			"normalized_png": str(normalized),
			"source_ref": str(raw),
			"dimensions": list(SIZE),
			"intended_layer": "small world-space memory-story vignette overlay near its stable A-Z anchor prop/place; optional subtle letter only",
			"story_hook": spec["story_hook"],
			"revisit_path_note": spec["revisit_path_note"],
			"prompt_design_notes": [
				"not a bare letter badge",
				"child-safe cozy town memory hook",
				"prop/place/revisit relationship visible",
				"no lesson panel, quiz, score, homework, or drill motif",
				"transparent RGBA overlay candidate; no runtime mapping",
			],
			"validation": validation,
			"risks": [
				"Proof-only synthesis candidate; needs future art-direction review beside the approved 1280 gameplay target before runtime use.",
				"Letter mark is intentionally tiny and secondary; keep prop/story hook primary.",
			],
		})
	contact_sheet = make_contact_sheet(items)
	pass_count = sum(1 for item in items if item["status"] == "pass")
	fail_count = len(items) - pass_count + len(coverage_failures)
	manifest = {
		"pack_id": "round179.az_story_vignettes_a_m",
		"round": "Round179",
		"worker": "Worker C",
		"status": "proof_only_transparent_candidates",
		"overall_gate": "pass" if len(items) == 13 and fail_count == 0 else "fail",
		"runtime_boundary": RUNTIME_BOUNDARY,
		"category": "az_memory_story_vignette_overlay_candidates_a_m",
		"scope": "Proof-only transparent A-Z memory-story vignette overlay candidates for anchors A-M; no runtime, ThemeProfile, AssetResolver, data, shared-test, todo, or lesson changes.",
		"generation_method": {
			"tool": "local PIL synthesis in asset pack script",
			"mode": "transparent RGBA normalized PNG plus raw #00ff00 chroma evidence",
			"postprocess": str(ROOT / "generate_validate_manifest.py"),
			"alpha_source": "Actual normalized PNG RGBA channels validated after synthesis; raw chroma files retained as provenance.",
			"notes": "Per LESSON-021 and LESSON-022, validation checks real alpha, transparent corners, edge contact, residue, and large background block risk.",
		},
		"proof": str(contact_sheet),
		"proofs": {
			"contact_sheet": str(contact_sheet),
			"raw_dir": str(ROOT / "raw"),
			"normalized_dir": str(ROOT / "normalized_256x192"),
		},
		"validation_summary": {
			"checks": [
				"A-M anchor/core-word coverage against data/maps/world_map.json",
				"RGBA alpha channel",
				"expected 256x192 dimensions",
				"non-empty alpha content",
				"transparent corners",
				"edge alpha/touch scan",
				"green/magenta residue scan",
				"opaque white and dark pinhole scan",
				"large opaque background block risk scan",
			],
			"pass_count": pass_count,
			"fail_count": fail_count,
			"coverage_failures": coverage_failures,
			"raw_chroma_source_count": len(items),
			"raw_chroma_color": "#00ff00",
		},
		"items": items,
	}
	manifest_path = ROOT / "manifest.json"
	manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
	if manifest["overall_gate"] != "pass":
		raise SystemExit(f"manifest gate failed: {manifest_path}")
	print(json.dumps({
		"manifest": str(manifest_path),
		"overall_gate": manifest["overall_gate"],
		"item_count": len(items),
		"pass_count": pass_count,
		"contact_sheet": str(contact_sheet),
	}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
	main()
