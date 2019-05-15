extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_devil()


func spawn_devil():

	var devil_scene = load("res://Scenes/NPCs/devil.tscn")
	var new_devil = devil_scene.instance()
	$NPCs.add_child(new_devil)
	new_devil.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


