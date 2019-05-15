"""
Note. Player is independent of Car, because we might want players to be able to switch cars.

"""

extends Node2D


#warning-ignore:unused_class_variable
var current_destination : Area2D


enum states { walking, driving, paused, dead }
var state = states.paused

var cash : float = 0.0
onready var tip_tracker = $CanvasLayer/TipTracker



func _init():
	Game.player = self

func _ready():
	state = states.driving
	$WalkingSprite.hide()
	current_destination = Game.map.pizza_factory


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func deliver_pizza(area):
	if area.has_method("receive_pizza"):
		# get your tip, set the compass back to the pizza factory
		print("You delivered a pizza!")
		cash += rand_range(0.05, 0.50)
		current_destination = Game.map.pizza_factory
		area.receive_pizza()


func _on_DestinationDetector_area_entered(area):
	if area == Game.devil:
		# get a cutscene, get a new car, go to underworld
		print("DEVIL! Imagine a cool cutscene, a new car, and the underworld map")

	elif area == current_destination:
		if area == Game.map.pizza_factory:
			current_destination = area.get_random_destination()
			if tip_tracker.has_method("reset_clock"):
				tip_tracker.reset_clock()
		else:
			deliver_pizza(area)
			if tip_tracker.has_method("reset_clock"):
				tip_tracker.reset_clock()


