extends Node

#warning-ignore:unused_class_variable
onready var building_scenes = {
	"Skyscraper" : preload("res://Scenes/Maps/DeliveryDestination/Buildings/Skyscraper.tscn") as PackedScene
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
