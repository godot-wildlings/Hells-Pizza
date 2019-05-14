extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("die_on_unstable_terrain")

func die_on_unstable_terrain():
	if has_node("DetectTile"):
		if $DetectTile.is_grass() == false:
			call_deferred("queue_free")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
