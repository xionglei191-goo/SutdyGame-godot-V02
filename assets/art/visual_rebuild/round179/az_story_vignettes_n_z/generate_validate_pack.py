#!/usr/bin/env python3
from __future__ import annotations

import json
import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parent
REPO = ROOT.parents[4]
WORLD_MAP = REPO / "data/maps/world_map.json"
OUT = ROOT / "normalized_256x192"
PROOF = ROOT / "proof"
SIZE = (256, 192)
RUNTIME_BOUNDARY = "proof_only_no_runtime_mapping_no_themeprofile_no_assetresolver_no_data_changes"


ITEMS = [
	{
		"letter": "N",
		"anchor_id": "anchor_n_net",
		"core_word": "Net",
		"slug": "anchor_n_net",
		"place_label": "School Yard",
		"story_hook": "A soft bug net leans by the school-yard flower patch, catching one floating leaf instead of an insect.",
		"revisit_path_note": "Return to School Yard after the morning walk and look near the play corner where the net waits by flowers.",
		"draw": "net",
	},
	{
		"letter": "O",
		"anchor_id": "anchor_o_orange",
		"core_word": "Orange",
		"slug": "anchor_o_orange",
		"place_label": "Shop Street",
		"story_hook": "A round orange sits in a tiny shop basket with a leaf tag, a snack remembered from the storefront.",
		"revisit_path_note": "Walk back to Shop Street and check the small basket near the supermarket entrance.",
		"draw": "orange",
	},
	{
		"letter": "P",
		"anchor_id": "anchor_p_panda",
		"core_word": "Panda",
		"slug": "anchor_p_panda",
		"place_label": "Animal Park",
		"story_hook": "A panda-faced picnic mat and bamboo sprout mark the Animal Park corner without adding a full character.",
		"revisit_path_note": "Revisit Animal Park and look by the cozy picnic patch where animal-memory props gather.",
		"draw": "panda",
	},
	{
		"letter": "Q",
		"anchor_id": "anchor_q_queen",
		"core_word": "Queen",
		"slug": "anchor_q_queen",
		"place_label": "Story + Culture Bridge",
		"story_hook": "A story crown rests on a blank picture book at the bridge, like a make-believe queen tale.",
		"revisit_path_note": "Return to Story + Culture Bridge and look beside the bookshop/story bench area.",
		"draw": "queen",
	},
	{
		"letter": "R",
		"anchor_id": "anchor_r_robot",
		"core_word": "Robot",
		"slug": "anchor_r_robot",
		"place_label": "School Yard",
		"story_hook": "A friendly toy robot holds a tiny chalk star near the School Yard playthings.",
		"revisit_path_note": "Revisit School Yard and check near the robot play corner after yard time.",
		"draw": "robot",
	},
	{
		"letter": "S",
		"anchor_id": "anchor_s_sun",
		"core_word": "Sun",
		"slug": "anchor_s_sun",
		"place_label": "Sun Scene",
		"story_hook": "A warm smiling sun rises behind a small town-sign hill, echoing the Sun Scene landmark.",
		"revisit_path_note": "Start at Sun Scene or pass the Morning School Walk and notice the same warm sun memory.",
		"draw": "sun",
	},
	{
		"letter": "T",
		"anchor_id": "anchor_t_taxi",
		"core_word": "Taxi",
		"slug": "anchor_t_taxi",
		"place_label": "Home",
		"story_hook": "A tiny taxi key charm rests on the home mat, suggesting the safe town ride connection.",
		"revisit_path_note": "Return Home and look by the entry mat where the small taxi charm is kept.",
		"draw": "taxi",
	},
	{
		"letter": "U",
		"anchor_id": "anchor_u_umbrella",
		"core_word": "Umbrella",
		"slug": "anchor_u_umbrella",
		"place_label": "Beach / Coast Edge",
		"story_hook": "A folded beach umbrella shelters two shells from a gentle coast drizzle.",
		"revisit_path_note": "Walk to Beach / Coast Edge and look beside the shoreline shells.",
		"draw": "umbrella",
	},
	{
		"letter": "V",
		"anchor_id": "anchor_v_violin",
		"core_word": "Violin",
		"slug": "anchor_v_violin",
		"place_label": "Story + Culture Bridge",
		"story_hook": "A tiny violin leans against the story bench, ready for a quiet bridge melody.",
		"revisit_path_note": "Return to Story + Culture Bridge and check the bench/bookshop music corner.",
		"draw": "violin",
	},
	{
		"letter": "W",
		"anchor_id": "anchor_w_watch",
		"core_word": "Watch",
		"slug": "anchor_w_watch",
		"place_label": "Home",
		"story_hook": "A round watch hangs from a cozy home peg beside a small morning ribbon.",
		"revisit_path_note": "Return Home and look by the entry wall where morning things are hung.",
		"draw": "watch",
	},
	{
		"letter": "X",
		"anchor_id": "anchor_x_x_mark_box",
		"core_word": "X-mark Box",
		"slug": "anchor_x_x_mark_box",
		"place_label": "Beach / Coast Edge",
		"story_hook": "A small wooden keepsake box has a soft X stitch and a shell, like a coast treasure clue.",
		"revisit_path_note": "Walk to Beach / Coast Edge and find the stitched box near the shells.",
		"draw": "xbox",
	},
	{
		"letter": "Y",
		"anchor_id": "anchor_y_yo_yo",
		"core_word": "Yo-yo",
		"slug": "anchor_y_yo_yo",
		"place_label": "School Yard",
		"story_hook": "A bright yo-yo rests on a chalk swirl in the School Yard play area.",
		"revisit_path_note": "Revisit School Yard and look near the toy corner after playtime.",
		"draw": "yoyo",
	},
	{
		"letter": "Z",
		"anchor_id": "anchor_z_zebra",
		"core_word": "Zebra",
		"slug": "anchor_z_zebra",
		"place_label": "Animal Park",
		"story_hook": "A zebra-striped cozy sign and grass tuft mark the Animal Park edge.",
		"revisit_path_note": "Return to Animal Park and check the striped sign near the soft grass path.",
		"draw": "zebra",
	},
]


def repo_rel(path: Path) -> str:
	return str(path.relative_to(REPO))


def font(size: int) -> ImageFont.ImageFont:
	for candidate in (
		"/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
		"/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
	):
		if Path(candidate).exists():
			return ImageFont.truetype(candidate, size)
	return ImageFont.load_default()


def ellipse(draw: ImageDraw.ImageDraw, box, fill, outline=None, width=1):
	draw.ellipse(box, fill=fill, outline=outline, width=width)


def rounded(draw: ImageDraw.ImageDraw, box, radius, fill, outline=None, width=1):
	draw.rounded_rectangle(box, radius=radius, fill=fill, outline=outline, width=width)


def line(draw: ImageDraw.ImageDraw, points, fill, width=1):
	draw.line(points, fill=fill, width=width, joint="curve")


def leaf(draw: ImageDraw.ImageDraw, cx, cy, color=(105, 170, 98, 255)):
	ellipse(draw, (cx - 12, cy - 7, cx + 12, cy + 7), color, (74, 132, 75, 255), 2)
	line(draw, (cx - 8, cy + 2, cx + 8, cy - 2), (74, 132, 75, 220), 1)


def sparkle(draw: ImageDraw.ImageDraw, x, y, color=(255, 239, 152, 240)):
	line(draw, (x, y - 8, x, y + 8), color, 2)
	line(draw, (x - 8, y, x + 8, y), color, 2)


def draw_vignette(kind: str) -> Image.Image:
	img = Image.new("RGBA", SIZE, (0, 0, 0, 0))
	d = ImageDraw.Draw(img)
	shadow = (82, 70, 58, 42)
	ellipse(d, (55, 150, 202, 174), shadow)
	if kind == "net":
		line(d, (78, 146, 137, 74), (139, 98, 54, 255), 8)
		line(d, (78, 146, 137, 74), (190, 137, 77, 255), 4)
		ellipse(d, (124, 38, 192, 98), (196, 231, 230, 150), (87, 151, 166, 255), 5)
		for x in range(132, 188, 12):
			line(d, (x, 47, x - 26, 91), (87, 151, 166, 120), 1)
		for y in range(52, 96, 12):
			line(d, (128, y, 184, y - 4), (87, 151, 166, 120), 1)
		leaf(d, 164, 67)
		for p in [(71, 148), (58, 153), (92, 152)]:
			leaf(d, *p, color=(117, 184, 108, 255))
	elif kind == "orange":
		rounded(d, (70, 119, 188, 165), 18, (198, 139, 83, 255), (146, 92, 57, 255), 3)
		for x in (84, 110, 136, 162):
			line(d, (x, 124, x + 5, 158), (146, 92, 57, 120), 2)
		ellipse(d, (94, 56, 162, 126), (244, 139, 54, 255), (200, 91, 39, 255), 4)
		ellipse(d, (112, 70, 130, 88), (255, 186, 92, 200))
		leaf(d, 151, 63, (82, 164, 80, 255))
	elif kind == "panda":
		rounded(d, (72, 116, 184, 164), 18, (174, 218, 146, 255), (95, 143, 88, 255), 3)
		ellipse(d, (82, 52, 174, 138), (248, 246, 226, 255), (69, 83, 78, 255), 4)
		ellipse(d, (75, 48, 101, 78), (69, 83, 78, 255))
		ellipse(d, (155, 48, 181, 78), (69, 83, 78, 255))
		ellipse(d, (100, 77, 124, 101), (69, 83, 78, 255))
		ellipse(d, (132, 77, 156, 101), (69, 83, 78, 255))
		ellipse(d, (112, 90, 120, 98), (248, 246, 226, 255))
		ellipse(d, (144, 90, 152, 98), (248, 246, 226, 255))
		ellipse(d, (123, 105, 135, 116), (69, 83, 78, 255))
		line(d, (190, 140, 203, 82), (95, 155, 88, 255), 5)
		leaf(d, 198, 94, (112, 177, 102, 255))
	elif kind == "queen":
		rounded(d, (76, 121, 180, 161), 8, (112, 151, 188, 255), (70, 104, 145, 255), 3)
		line(d, (83, 129, 173, 129), (238, 231, 193, 255), 3)
		d.polygon([(95, 111), (111, 70), (129, 106), (147, 70), (163, 111)], fill=(251, 205, 79, 255), outline=(189, 135, 45, 255))
		rounded(d, (92, 103, 166, 124), 6, (251, 205, 79, 255), (189, 135, 45, 255), 3)
		ellipse(d, (106, 76, 116, 86), (234, 101, 118, 255))
		ellipse(d, (142, 76, 152, 86), (106, 174, 199, 255))
		sparkle(d, 68, 91)
	elif kind == "robot":
		rounded(d, (87, 65, 169, 133), 16, (151, 205, 214, 255), (73, 119, 137, 255), 4)
		rounded(d, (98, 103, 158, 154), 12, (109, 158, 181, 255), (73, 119, 137, 255), 4)
		line(d, (128, 65, 128, 45), (73, 119, 137, 255), 4)
		ellipse(d, (120, 34, 136, 50), (255, 213, 99, 255), (180, 132, 52, 255), 2)
		ellipse(d, (105, 86, 119, 100), (52, 81, 92, 255))
		ellipse(d, (137, 86, 151, 100), (52, 81, 92, 255))
		line(d, (112, 117, 144, 117), (52, 81, 92, 255), 3)
		sparkle(d, 184, 104, (255, 231, 129, 255))
	elif kind == "sun":
		for a in range(0, 360, 30):
			r = math.radians(a)
			line(d, (128 + math.cos(r) * 42, 83 + math.sin(r) * 42, 128 + math.cos(r) * 64, 83 + math.sin(r) * 64), (253, 203, 74, 210), 5)
		ellipse(d, (83, 38, 173, 128), (255, 212, 83, 255), (215, 150, 51, 255), 4)
		ellipse(d, (108, 75, 117, 84), (121, 93, 73, 255))
		ellipse(d, (139, 75, 148, 84), (121, 93, 73, 255))
		line(d, (114, 99, 128, 107, 144, 99), (121, 93, 73, 255), 3)
		rounded(d, (74, 132, 182, 163), 12, (122, 182, 128, 255), (79, 133, 88, 255), 3)
	elif kind == "taxi":
		rounded(d, (62, 127, 194, 163), 14, (177, 132, 92, 255), (124, 83, 58, 255), 3)
		rounded(d, (91, 76, 166, 126), 12, (255, 201, 70, 255), (184, 131, 48, 255), 4)
		rounded(d, (107, 58, 150, 82), 8, (255, 221, 102, 255), (184, 131, 48, 255), 3)
		rounded(d, (104, 86, 151, 110), 6, (137, 202, 220, 230), (85, 137, 154, 255), 2)
		ellipse(d, (96, 118, 115, 137), (65, 72, 75, 255))
		ellipse(d, (143, 118, 162, 137), (65, 72, 75, 255))
		line(d, (172, 82, 199, 62), (184, 131, 48, 255), 5)
		ellipse(d, (197, 55, 213, 71), (255, 221, 102, 255), (184, 131, 48, 255), 3)
	elif kind == "umbrella":
		d.pieslice((69, 52, 187, 160), 180, 360, fill=(238, 104, 117, 255), outline=(166, 76, 98, 255), width=4)
		line(d, (128, 106, 128, 154), (103, 116, 126, 255), 5)
		line(d, (128, 154, 148, 154, 148, 142), (103, 116, 126, 255), 5)
		for x in (98, 128, 158):
			line(d, (128, 106, x, 68), (255, 188, 143, 210), 3)
		ellipse(d, (74, 145, 108, 162), (241, 224, 181, 255), (168, 137, 97, 255), 2)
		ellipse(d, (170, 146, 199, 160), (232, 211, 169, 255), (168, 137, 97, 255), 2)
	elif kind == "violin":
		line(d, (84, 151, 177, 58), (77, 61, 48, 255), 4)
		ellipse(d, (92, 87, 140, 135), (180, 103, 58, 255), (117, 71, 47, 255), 4)
		ellipse(d, (116, 59, 158, 104), (196, 117, 64, 255), (117, 71, 47, 255), 4)
		rounded(d, (133, 47, 149, 77), 6, (117, 71, 47, 255))
		line(d, (132, 68, 115, 128), (68, 49, 40, 255), 2)
		line(d, (140, 68, 123, 130), (68, 49, 40, 255), 2)
		rounded(d, (74, 136, 182, 162), 8, (131, 98, 71, 255), (92, 65, 50, 255), 3)
	elif kind == "watch":
		line(d, (128, 44, 128, 61), (92, 106, 115, 255), 5)
		ellipse(d, (83, 60, 173, 150), (236, 226, 189, 255), (83, 112, 128, 255), 6)
		ellipse(d, (96, 73, 160, 137), (251, 246, 223, 255), (147, 169, 170, 255), 2)
		line(d, (128, 105, 128, 84), (80, 91, 99, 255), 4)
		line(d, (128, 105, 146, 114), (80, 91, 99, 255), 4)
		rounded(d, (66, 125, 190, 163), 10, (151, 110, 80, 255), (98, 69, 52, 255), 3)
		line(d, (84, 132, 181, 132), (201, 158, 112, 180), 2)
	elif kind == "xbox":
		rounded(d, (77, 84, 181, 151), 13, (193, 136, 76, 255), (119, 77, 48, 255), 4)
		rounded(d, (86, 67, 172, 98), 12, (218, 164, 91, 255), (119, 77, 48, 255), 4)
		line(d, (112, 105, 145, 137), (238, 230, 198, 255), 6)
		line(d, (145, 105, 112, 137), (238, 230, 198, 255), 6)
		ellipse(d, (52, 139, 88, 159), (235, 218, 178, 255), (165, 130, 90, 255), 2)
		leaf(d, 190, 119, (114, 173, 121, 255))
	elif kind == "yoyo":
		ellipse(d, (91, 73, 157, 139), (95, 164, 219, 255), (54, 99, 157, 255), 5)
		ellipse(d, (109, 91, 139, 121), (255, 209, 84, 255), (201, 143, 48, 255), 3)
		line(d, (157, 100, 190, 73, 190, 51), (104, 92, 82, 255), 3)
		ellipse(d, (184, 41, 196, 53), (238, 104, 117, 255), (159, 71, 90, 255), 2)
		line(d, (63, 154, 109, 143, 151, 154, 197, 141), (235, 225, 184, 255), 3)
	elif kind == "zebra":
		rounded(d, (78, 87, 178, 145), 14, (241, 239, 219, 255), (74, 82, 79, 255), 4)
		for x in (92, 112, 136, 160):
			line(d, (x, 91, x - 12, 142), (74, 82, 79, 255), 6)
		rounded(d, (92, 61, 163, 91), 10, (241, 239, 219, 255), (74, 82, 79, 255), 4)
		ellipse(d, (161, 55, 181, 76), (241, 239, 219, 255), (74, 82, 79, 255), 3)
		line(d, (101, 145, 101, 160), (74, 82, 79, 255), 5)
		line(d, (156, 145, 156, 160), (74, 82, 79, 255), 5)
		for p in [(61, 154), (188, 153), (207, 149)]:
			leaf(d, *p, color=(117, 184, 108, 255))
	else:
		raise ValueError(kind)
	return img


def alpha_checks(path: Path) -> dict:
	img = Image.open(path)
	rgba = img.convert("RGBA")
	alpha = rgba.getchannel("A")
	w, h = rgba.size
	alpha_extrema = alpha.getextrema()
	pixels = rgba.load()
	visible = 0
	semi = 0
	bbox = alpha.getbbox()
	pixel_data = rgba.get_flattened_data() if hasattr(rgba, "get_flattened_data") else rgba.getdata()
	for _, _, _, a in pixel_data:
		if a > 0:
			visible += 1
			if a < 255:
				semi += 1
	corners = [
		alpha.crop((0, 0, 24, 24)).getextrema()[1],
		alpha.crop((w - 24, 0, w, 24)).getextrema()[1],
		alpha.crop((0, h - 24, 24, h)).getextrema()[1],
		alpha.crop((w - 24, h - 24, w, h)).getextrema()[1],
	]
	edge_visible = 0
	for x in range(w):
		for y in (0, h - 1):
			if pixels[x, y][3] > 8:
				edge_visible += 1
	for y in range(h):
		for x in (0, w - 1):
			if pixels[x, y][3] > 8:
				edge_visible += 1
	block_count = 0
	if bbox is not None:
		bx0, by0, bx1, by1 = bbox
		bbox_area = (bx1 - bx0) * (by1 - by0)
		bbox_fill = visible / float(max(1, bbox_area))
		if bbox_area > w * h * 0.68 and bbox_fill > 0.82:
			block_count = 1
	key_like = 0
	pixel_data = rgba.get_flattened_data() if hasattr(rgba, "get_flattened_data") else rgba.getdata()
	for r, g, b, a in pixel_data:
		if a > 8 and ((g > 220 and r < 70 and b < 70) or (r > 220 and b > 220 and g < 90)):
			key_like += 1
	coverage = round(visible / float(w * h), 4)
	passed = (
		img.mode == "RGBA"
		and tuple(img.size) == SIZE
		and alpha_extrema[0] == 0
		and alpha_extrema[1] >= 220
		and max(corners) == 0
		and 0.08 <= coverage <= 0.55
		and edge_visible == 0
		and block_count == 0
		and key_like == 0
		and bbox is not None
	)
	return {
		"dimensions": [w, h],
		"mode": img.mode,
		"alpha_extrema": list(alpha_extrema),
		"visible_pixel_count": visible,
		"visible_coverage_ratio": coverage,
		"semi_transparent_pixel_count": semi,
		"transparent_corner_alpha_max": max(corners),
		"visible_edge_residue_pixel_count": edge_visible,
		"suspicious_key_residue_pixel_count": key_like,
		"visual_background_block_count": block_count,
		"background_block_check": "pass" if block_count == 0 else "fail",
		"pass": passed,
	}


def extract_world_anchors() -> dict[str, dict]:
	data = json.loads(WORLD_MAP.read_text(encoding="utf-8"))
	found: dict[str, dict] = {}
	letters = {item["letter"] for item in ITEMS}

	def walk(value) -> None:
		if isinstance(value, dict):
			if {"letter", "anchor_id", "core_word"} <= set(value.keys()) and value.get("letter") in letters:
				found[value["anchor_id"]] = {
					"letter": value["letter"],
					"core_word": value["core_word"],
					"place_id": value.get("place_id", ""),
				}
			for child in value.values():
				walk(child)
		elif isinstance(value, list):
			for child in value:
				walk(child)

	walk(data)
	return found


def make_contact_sheet(items: list[dict]) -> Path:
	cell_w, cell_h = 330, 258
	cols = 4
	rows = math.ceil(len(items) / cols)
	sheet = Image.new("RGBA", (cols * cell_w, rows * cell_h), (246, 241, 228, 255))
	d = ImageDraw.Draw(sheet)
	label_font = font(18)
	small_font = font(13)
	for idx, item in enumerate(items):
		x = (idx % cols) * cell_w
		y = (idx // cols) * cell_h
		for yy in range(y + 12, y + 204, 16):
			for xx in range(x + 34, x + 290, 16):
				fill = (232, 225, 211, 255) if ((xx + yy) // 16) % 2 else (249, 246, 238, 255)
				d.rectangle((xx, yy, xx + 15, yy + 15), fill=fill)
		img = Image.open(REPO / item["normalized_png"]).convert("RGBA")
		sheet.alpha_composite(img, (x + 34, y + 12))
		d.text((x + 18, y + 209), f'{item["letter"]}  {item["core_word"]}', fill=(61, 62, 54, 255), font=label_font)
		d.text((x + 18, y + 233), item["anchor_id"], fill=(89, 98, 96, 255), font=small_font)
	path = PROOF / "round179_az_story_vignettes_n_z_contact_sheet.png"
	sheet.convert("RGB").save(path)
	return path


def main() -> None:
	OUT.mkdir(parents=True, exist_ok=True)
	PROOF.mkdir(parents=True, exist_ok=True)
	world_anchors = extract_world_anchors()
	manifest_items = []
	for spec in ITEMS:
		world_anchor = world_anchors.get(spec["anchor_id"])
		if world_anchor is None:
			raise SystemExit(f"Missing anchor_id in world_map anchors: {spec['anchor_id']}")
		if world_anchor["letter"] != spec["letter"]:
			raise SystemExit(f"Letter mismatch for {spec['anchor_id']}: {world_anchor['letter']} != {spec['letter']}")
		if world_anchor["core_word"] != spec["core_word"]:
			raise SystemExit(f"Core word mismatch for {spec['anchor_id']}: {world_anchor['core_word']} != {spec['core_word']}")
		image = draw_vignette(spec["draw"])
		out_path = OUT / f"{spec['slug']}_256x192.png"
		image.save(out_path)
		checks = alpha_checks(out_path)
		status = "pass" if checks["pass"] else "fail"
		manifest_items.append({
			"id": f"az_story_vignette.{spec['slug']}",
			"letter": spec["letter"],
			"anchor_id": spec["anchor_id"],
			"core_word": spec["core_word"],
			"place_label": spec["place_label"],
			"place_id": world_anchor["place_id"],
			"story_hook": spec["story_hook"],
			"revisit_path_note": spec["revisit_path_note"],
			"status": status,
			"normalized_png": repo_rel(out_path),
			"main_ref": repo_rel(out_path),
			"dimensions": list(SIZE),
			"format": "PNG RGBA",
			"checks": checks,
			"runtime_boundary": RUNTIME_BOUNDARY,
			"risks": [
				"Proof-only locally synthesized visual candidate; style must be art-directed before production use.",
				"No runtime, data, ThemeProfile, or AssetResolver mapping."
			],
		})
	proof_path = make_contact_sheet(manifest_items)
	all_pass = all(item["status"] == "pass" for item in manifest_items)
	manifest = {
		"round": 179,
		"pack": "az_story_vignettes_n_z",
		"category": "proof_only_az_memory_story_vignette_overlay_candidates",
		"overall_gate": "pass" if all_pass else "fail",
		"runtime_boundary": RUNTIME_BOUNDARY,
		"proof": repo_rel(proof_path),
		"normalization": {
			"canvas_px": list(SIZE),
			"format": "PNG RGBA",
			"lesson_021_background_block_policy": "Contact sheet checker proof and per-item visual_background_block_count gate are included.",
			"lesson_022_alpha_policy": "Actual file alpha is validated; transparent corners and alpha extrema are recorded per item."
		},
		"coverage_check": {
			"letters_required": [item["letter"] for item in ITEMS],
			"anchors_required": [item["anchor_id"] for item in ITEMS],
			"world_map_source": "data/maps/world_map.json",
			"result": "pass" if all_pass else "fail",
		},
		"counts": {
			"items_total": len(manifest_items),
			"items_pass": sum(1 for item in manifest_items if item["status"] == "pass"),
			"items_fail": sum(1 for item in manifest_items if item["status"] != "pass"),
		},
		"items": manifest_items,
	}
	(ROOT / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
	if not all_pass:
		raise SystemExit("One or more vignette candidates failed validation")
	print(json.dumps({
		"overall_gate": manifest["overall_gate"],
		"item_count": len(manifest_items),
		"proof": repo_rel(proof_path),
		"manifest": repo_rel(ROOT / "manifest.json"),
	}, indent=2))


if __name__ == "__main__":
	main()
