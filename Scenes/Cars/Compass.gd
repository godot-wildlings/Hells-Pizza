extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().current_destination != null:
#		var my_pos = get_global_position()
#		var target_pos = get_parent().current_destination.get_global_position()
#		var angle = Vector2.RIGHT.angle_to_point(target_pos - my_pos)
#		set_global_rotation(angle)
		look_at(get_parent().current_destination.get_global_position())
