extends Node2D

#onready var terrain = Game.map.terrain
#onready var tiles = Game.map.terrain.tiles


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func is_safe() -> bool:
	var terrain = Game.map.terrain

	if terrain == null or is_instance_valid(terrain) == false:
		push_error("Game.map.terrain is not yet registered")

	var safe : bool = true
	var my_pos : Vector2 = get_global_position()

	if terrain.compare_tile(my_pos, "lava") == true:
		safe = false
	elif terrain.compare_tile(my_pos, "water") == true:
		safe = false
	return safe


func get_tile_idx(location):
	var terrain = Game.map.terrain

	var tile_type : int = terrain.detect_tile(location)
	return tile_type


func is_asphalt() -> bool:
	var terrain = Game.map.terrain
	#var tiles = terrain.tiles
	if terrain.compare_tile(get_global_position(), "asphalt") == true:
		return true
	else:
		return false

func is_grass() -> bool:
	var terrain = Game.map.terrain
	if terrain.compare_tile(get_global_position(), "grass") == true:
		return true
	else:
		return false

func is_dirt() -> bool:
	var terrain = Game.map.terrain
	#var tiles = terrain.tiles

	if terrain.compare_tile(get_global_position(), "dirt") == true:
		return true
	else:
		return false


