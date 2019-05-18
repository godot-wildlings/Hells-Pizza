extends Node2D

#warning-ignore:unused_class_variable
onready var terrain = $UnderworldTerrain

#warning-ignore:unused_class_variable
onready var pizza_factory = $PizzaFactory

#func _init():
#	Game.map = self

func _ready():
	Game.map = self

func spawn_mom():
	print("spawning mom now")
	var mom_scene = load("res://Scenes/NPCs/Mom.tscn")
	var new_mom = mom_scene.instance()
	$Pedestrians.add_child(new_mom)
	new_mom.start()
	print(new_mom , ": ", new_mom.name)

func spawn_exit():
	var exit_scene = load("res://Scenes/Maps/Underworld/Exit.tscn")
	var new_exit = exit_scene.instance()
	add_child(new_exit)
	new_exit.start()



func add_car(car_node):
	$Cars.add_child(car_node)

func add_pedestrian(pedestrian_node):
	$Pedestrians.add_child(pedestrian_node)





func _on_MomSpawnTimer_timeout():
	spawn_mom()
