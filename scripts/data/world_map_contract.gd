extends RefCounted
class_name WorldMapContract

const REQUIRED_TOP_LEVEL_FIELDS: Array[String] = [
	"map_id",
	"version",
	"canvas_size",
	"cell_size",
	"theme_id",
	"districts",
	"roads",
	"places",
	"memory_anchors",
	"collision_cells",
	"interaction_cells",
]

const ROUTE_ORDER_BY_LETTER: Dictionary = {
	"A": 1,
	"B": 2,
	"C": 3,
	"D": 4,
	"E": 5,
	"F": 6,
	"G": 7,
	"H": 8,
	"I": 9,
	"J": 10,
	"K": 11,
	"L": 12,
	"M": 13,
	"N": 14,
	"O": 15,
	"P": 16,
	"Q": 17,
	"R": 18,
	"S": 19,
	"T": 20,
	"U": 21,
	"V": 22,
	"W": 23,
	"X": 24,
	"Y": 25,
	"Z": 26,
}

const CORE_WORD_BY_LETTER: Dictionary = {
	"A": "Apple",
	"B": "Bear",
	"C": "Clock",
	"D": "Dog",
	"K": "Kite",
	"O": "Orange",
	"S": "Sun",
	"T": "Taxi",
	"W": "Watch",
}

static func validate_map(map_data: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	var ids: Dictionary = {}
	var districts_by_id: Dictionary = {}
	var places_by_id: Dictionary = {}
	var occupied_cells: Dictionary = {}
	var route_orders: Dictionary = {}
	var road_cells: Dictionary = {}

	for field in REQUIRED_TOP_LEVEL_FIELDS:
		if not map_data.has(field):
			errors.append("Missing top-level field: %s" % field)

	for district in map_data.get("districts", []):
		_register_unique_id(district.get("district_id", ""), "district_id", ids, errors)
		districts_by_id[district.get("district_id", "")] = district

	for road in map_data.get("roads", []):
		_register_unique_id(road.get("road_id", ""), "road_id", ids, errors)
		for cell in road.get("cells", []):
			road_cells[_cell_key(cell)] = true

	for place in map_data.get("places", []):
		_register_unique_id(place.get("place_id", ""), "place_id", ids, errors)
		places_by_id[place.get("place_id", "")] = place
		_validate_place(place, districts_by_id, occupied_cells, errors)

	for cell in map_data.get("collision_cells", []):
		occupied_cells[_cell_key(cell)] = true

	for interaction in map_data.get("interaction_cells", []):
		_register_unique_id(interaction.get("interaction_id", ""), "interaction_id", ids, errors)
		if not places_by_id.has(interaction.get("place_id", "")):
			errors.append("interaction has unknown place_id: %s" % interaction.get("interaction_id", ""))
		if occupied_cells.has(_cell_key(interaction.get("cell", {}))):
			errors.append("interaction cell overlaps occupied cell: %s" % interaction.get("interaction_id", ""))

	for place in map_data.get("places", []):
		_validate_road_connection(place, road_cells, errors)

	for anchor in map_data.get("memory_anchors", []):
		_register_unique_id(anchor.get("anchor_id", ""), "anchor_id", ids, errors)
		_validate_anchor(anchor, places_by_id, route_orders, errors)

	return errors

static func _register_unique_id(id_value: String, field_name: String, ids: Dictionary, errors: Array[String]) -> void:
	if id_value.is_empty():
		errors.append("Empty id in field: %s" % field_name)
		return
	if ids.has(id_value):
		errors.append("Duplicate id: %s" % id_value)
	else:
		ids[id_value] = true

static func _validate_place(place: Dictionary, districts_by_id: Dictionary, occupied_cells: Dictionary, errors: Array[String]) -> void:
	var district_id: String = place.get("district_id", "")
	if not districts_by_id.has(district_id):
		errors.append("place has unknown district: %s" % place.get("place_id", ""))
		return

	var district: Dictionary = districts_by_id[district_id]
	if not district.get("allowed_place_types", []).has(place.get("place_type", "")):
		errors.append("place type not allowed in district: %s" % place.get("place_id", ""))
	var rect: Dictionary = district.get("rect_cells", {})
	var position: Dictionary = place.get("position", {})
	if not _cell_in_rect(position, rect):
		errors.append("place position outside district: %s" % place.get("place_id", ""))

	var interaction_cell: Dictionary = place.get("interaction_cell", {})
	for occupied in place.get("occupied_cells", []):
		occupied_cells[_cell_key(occupied)] = true
		if _same_cell(occupied, interaction_cell):
			errors.append("place interaction overlaps occupied cell: %s" % place.get("place_id", ""))

static func _validate_anchor(anchor: Dictionary, places_by_id: Dictionary, route_orders: Dictionary, errors: Array[String]) -> void:
	var anchor_id: String = anchor.get("anchor_id", "")
	var place_id: String = anchor.get("place_id", "")
	var letter: String = anchor.get("letter", "")
	var route_order: int = int(anchor.get("route_order", 0))

	if not places_by_id.has(place_id):
		errors.append("anchor has unknown place_id: %s" % anchor_id)
	if not ROUTE_ORDER_BY_LETTER.has(letter):
		errors.append("anchor has invalid letter: %s" % anchor_id)
	elif ROUTE_ORDER_BY_LETTER[letter] != route_order:
		errors.append("anchor route_order does not match A-Z order: %s" % anchor_id)
	if CORE_WORD_BY_LETTER.has(letter) and CORE_WORD_BY_LETTER[letter] != anchor.get("core_word", ""):
		errors.append("anchor core_word does not match fixed encoding: %s" % anchor_id)
	if route_orders.has(route_order):
		errors.append("Duplicate anchor route_order: %s" % route_order)
	else:
		route_orders[route_order] = true

static func _validate_road_connection(place: Dictionary, road_cells: Dictionary, errors: Array[String]) -> void:
	if place.get("place_type", "") not in ["shop", "bus_station", "transport"]:
		return
	var cell: Dictionary = place.get("interaction_cell", {})
	var x: int = int(cell.get("x", -1))
	var y: int = int(cell.get("y", -1))
	for candidate in [
		{"x": x, "y": y},
		{"x": x - 1, "y": y},
		{"x": x + 1, "y": y},
		{"x": x, "y": y - 1},
		{"x": x, "y": y + 1},
	]:
		if road_cells.has(_cell_key(candidate)):
			return
	errors.append("place interaction is not connected to a road: %s" % place.get("place_id", ""))

static func _cell_in_rect(cell: Dictionary, rect: Dictionary) -> bool:
	var x: int = int(cell.get("x", -1))
	var y: int = int(cell.get("y", -1))
	var rx: int = int(rect.get("x", 0))
	var ry: int = int(rect.get("y", 0))
	var rw: int = int(rect.get("w", 0))
	var rh: int = int(rect.get("h", 0))
	return x >= rx and x < rx + rw and y >= ry and y < ry + rh

static func _same_cell(a: Dictionary, b: Dictionary) -> bool:
	return int(a.get("x", -1)) == int(b.get("x", -2)) and int(a.get("y", -1)) == int(b.get("y", -2))

static func _cell_key(cell: Dictionary) -> String:
	return "%s,%s" % [int(cell.get("x", -1)), int(cell.get("y", -1))]
