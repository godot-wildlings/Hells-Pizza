"""
Load levels
Remove levels
Relay signals and object references if necessary

"""


extends Node

var level_container : Node2D
var current_level

func _ready() -> void:
	Game.main = self
	$CanvasLayer/IntroScreen.show()
	level_container = $Levels

func load_level(level_name : String ) -> void:
	var levels : Dictionary = {
			"Overworld" : "res://Scenes/Maps/Overworld/Overworld.tscn",
			"Underworld" : "res://Scenes/Maps/Underworld/Underworld.tscn",
		}

	remove_old_level()

	var level_scene_path = levels[level_name]
	if level_scene_path != "":
		var level_scene = load(levels[level_name])
		var new_level = level_scene.instance()
		level_container.add_child(new_level)
		current_level = new_level
		

func remove_old_level():
	if current_level != null and is_instance_valid(current_level):
		current_level.call_deferred("queue_free")