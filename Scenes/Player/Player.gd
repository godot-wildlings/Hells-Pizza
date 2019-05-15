"""
Note. Player is independent of Car, because we might want players to be able to switch cars.

"""

extends Node2D

#warning-ignore:unused_class_variable
var current_destination : Area2D

func _init():
	Game.player = self

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
