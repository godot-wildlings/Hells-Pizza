"""
Note. Player is independent of Car, because we might want players to be able to switch cars.

"""

extends Node2D


#warning-ignore:unused_class_variable
var current_destination : Area2D

enum states { walking, driving, paused, dead }
var state = states.paused


func _init():
	Game.player = self

func _ready():
	state = states.driving
	$WalkingSprite.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DestinationDetector_area_entered(area):
	if area == Game.devil:
		# get a cutscene, get a new car, go to underworld
		print("DEVIL! Imagine a cool cutscene, a new car, and the underworld map")

	elif area == current_destination:
		# get your tip, set the compass back to the pizza factory
		print("You delivered a pizza!")
