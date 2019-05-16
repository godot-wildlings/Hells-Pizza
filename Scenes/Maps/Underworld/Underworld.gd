extends Node2D

#warning-ignore:unused_class_variable
onready var terrain = $UnderworldTerrain

#warning-ignore:unused_class_variable
onready var pizza_factory = $PizzaFactory

#func _init():
#	Game.map = self

func _ready():
	Game.map = self


func add_car(car_node):
	$Cars.add_child(car_node)

func add_pedestrian(pedestrian_node):
	$Pedestrians.add_child(pedestrian_node)



