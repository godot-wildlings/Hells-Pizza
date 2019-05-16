extends Node2D

#onready var terrain = Game.map.terrain
#onready var tiles = Game.map.terrain.tiles


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func is_safe() -> bool:
	var terrain = Game.map.terrain
	var tiles = terrain.tiles

	if terrain == null or is_instance_valid(terrain) == false:
		push_error("Game.map.terrain is not yet registered")

	var safe : bool = true
	var my_pos : Vector2 = get_global_position()
	var tile_type : int = terrain.detect_tile(my_pos)
	if tile_type == tiles.lava_hot or tile_type == tiles.lava_cold:
		print("Lava")
		safe = false
	elif tile_type == tiles.water_shallow or tile_type == tiles.water_deep:
		#print("Water")
		safe = false
	return safe


func get_tile_idx(location):
	var terrain = Game.map.terrain

	var tile_type : int = terrain.detect_tile(location)
	return tile_type


func is_asphalt() -> bool:
	var terrain = Game.map.terrain
	var tiles = terrain.tiles

	if get_tile_idx(get_global_position()) == tiles.asphalt:
		return true
	else:
		return false

func is_grass() -> bool:
	var terrain = Game.map.terrain
	var tiles = terrain.tiles
	if get_tile_idx(get_global_position()) == tiles.grass:
		return true
	else:
		return false

func is_dirt() -> bool:
	var terrain = Game.map.terrain
	var tiles = terrain.tiles

	if get_tile_idx(get_global_position()) == tiles.ground:
		return true
	else:
		return false

