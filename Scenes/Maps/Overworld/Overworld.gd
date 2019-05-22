extends Node2D

#warning-ignore:unused_class_variable
onready var terrain = $OverworldTerrain
#warning-ignore:unused_class_variable
onready var pizza_factory = $PizzaFactory


func _init():
	#Game.map = self
	pass

func _ready():
	Game.map = self
	spawn_portal_to_underworld()

func spawn_portal_to_underworld():
	var portal_scene = load("res://Scenes/Maps/UnderworldPortal/UnderworldPortal.tscn")
	var new_portal = portal_scene.instance()
	$Portals.add_child(new_portal)
	new_portal.start()


func add_car(car_node):
	$Cars.add_child(car_node)

func add_pedestrian(pedestrian_node):
	$Pedestrians.add_child(pedestrian_node)
