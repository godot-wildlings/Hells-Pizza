extends Node

#warning-ignore:unused_class_variable
onready var building_scenes = {
	"Skyscraper" : preload("res://Scenes/Maps/DeliveryDestination/Buildings/Skyscraper.tscn") as PackedScene,
	"House1" : preload("res://Scenes/Maps/DeliveryDestination/Buildings/House1.tscn") as PackedScene
}

#warning-ignore:unused_class_variable
onready var demon_scenes = {
	"Imp" : preload("res://Scenes/Maps/DeliveryDestination/Demons/Imp.tscn") as PackedScene
}



#warning-ignore:unused_class_variable
var player : Node2D
#warning-ignore:unused_class_variable

var devil : Area2D
#warning-ignore:unused_class_variable
var mom : Area2D
#warning-ignore:unused_class_variable
var exit : Area2D
#warning-ignore:unused_class_variable
var camera : Camera2D
#warning-ignore:unused_class_variable
var camera_focus : Node2D
#warning-ignore:unused_class_variable
var map : Node
#warning-ignore:unused_class_variable
var main : Node
#warning-ignore:unused_class_variable
enum stages { OVERWORLD, UNDERWORLD, ESCAPE }
#warning-ignore:unused_class_variable
var stage = stages.OVERWORLD
#warning-ignore:unused_class_variable
var time_elapsed: float = 0
#warning-ignore:unused_class_variable
var ticks: int = 0


func _process(delta):
	ticks += 1
	time_elapsed += delta
