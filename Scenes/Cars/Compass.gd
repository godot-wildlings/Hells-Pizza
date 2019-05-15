extends Node2D

enum targets { DELIVERY, DEVIL }
export (targets) var target = targets.DELIVERY

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#warning-ignore:unused_argument
func _process(delta):
	if target == targets.DELIVERY:
		if Game.player.current_destination != null:
			look_at(Game.player.current_destination.get_global_position())
	elif target == targets.DEVIL:
		look_at(Game.devil.get_global_position())

