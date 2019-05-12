extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var my_pos : Vector2 = get_global_position()
	var cell_location : Vector2 = Game.map.world_to_map(my_pos)
	var cell = Game.map.get_cell(cell_location.x, cell_location.y)

	if cell == Game.map.HOT_LAVA or cell == Game.map.COLD_LAVA:
		print("LAVA!")
