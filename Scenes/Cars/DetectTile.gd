extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#warning-ignore:unused_argument
func _process(delta):
	var my_pos : Vector2 = get_global_position()
	var cell_location : Vector2 = Game.map.world_to_map(my_pos)
	var cell = Game.map.get_cell(int(cell_location.x), int(cell_location.y))
	if cell == Game.map.tiles.lava_hot or cell == Game.map.tiles.lava_cold:
		print("LAVA!")
	elif cell == Game.map.tiles.water_deep or cell == Game.map.tiles.water_shallow:
		print("Water")

