extends Node2D

enum targets { DELIVERY, DEVIL }
export (targets) var target = targets.DELIVERY

enum states { off, on }
var state = states.off

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#warning-ignore:unused_argument
func _process(delta):
	if visible == false:
		return

	if state == states.on:
		if target == targets.DELIVERY:
			if Game.player.current_destination != null:
				var destination = Game.player.current_destination
				if is_instance_valid(destination):
					look_at(Game.player.current_destination.get_global_position())
				else:
					push_warning("Compass can't find delivery destination. Was it queued_free?")
		elif target == targets.DEVIL:
			if is_instance_valid(Game.devil):
				look_at(Game.devil.get_global_position())
			else:
				if visible:
					hide()

func turn_on():
	state = states.on

func turn_off():
	state = states.off
