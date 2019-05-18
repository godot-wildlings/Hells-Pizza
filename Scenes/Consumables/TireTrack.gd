extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_as_toplevel(true)
	pass


func _on_DurationTimer_timeout():
	call_deferred("queue_free")
