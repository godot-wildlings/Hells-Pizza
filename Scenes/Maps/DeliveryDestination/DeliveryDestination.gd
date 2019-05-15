extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func die_on_unstable_terrain():
	if has_node("DetectTile"):
		if $DetectTile.is_grass() == false:
			$DestructionTimer.start()

func die_if_overlapping():
	var areas = get_overlapping_areas()

	if areas.size() > 0:
		for area in areas:
			if get_position_in_parent() < area.get_position_in_parent():
				$DestructionTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ScanTimer_timeout():
	die_on_unstable_terrain()
	die_if_overlapping()



func _on_DestructionTimer_timeout():
	call_deferred("queue_free")

func receive_pizza():
	set_modulate(Color.white)
	#$CollisionShape2D.call_deferred("set_disabled", true)