extends Node2D

onready var terrain = Game.map.terrain
onready var tiles = Game.map.terrain.tiles


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#warning-ignore:unused_argument
func _process(delta):
	pass

func is_safe() -> bool:
	var safe : bool = true
	var my_pos : Vector2 = get_global_position()
	var tile_type : int = terrain.detect_tile(my_pos)
	if tile_type == tiles.lava_hot or tile_type == tiles.lava_cold:
		print("Lava")
		safe = false
	elif tile_type == tiles.water_shallow or tile_type == tiles.water_deep:
		print("Water")
		safe = false
	return safe

func is_asphalt() -> bool:
	var tile_type : int = terrain.detect_tile(get_global_position())
	if tile_type == tiles.asphalt:
		return true
	else:
		return false

func is_grass() -> bool:
	var tile_type : int = terrain.detect_tile(get_global_position())
	if tile_type == tiles.grass:
		return true
	else:
		return false
