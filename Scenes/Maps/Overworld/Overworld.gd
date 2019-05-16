extends Node2D

#warning-ignore:unused_class_variable
onready var terrain = $OverworldTerrain
#warning-ignore:unused_class_variable
onready var pizza_factory = $PizzaFactory


func _init():
	Game.map = self

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_devil()


func spawn_devil():

	var devil_scene = load("res://Scenes/NPCs/Devil.tscn")
	var new_devil = devil_scene.instance()
	$NPCs.add_child(new_devil)
	new_devil.start()

func add_car(car_node):
	$Cars.add_child(car_node)

func add_pedestrian(pedestrian_node):
	$Pedestrians.add_child(pedestrian_node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


