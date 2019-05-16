extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$ScanTimer.start()

func die_on_unstable_terrain():
	if has_node("DetectTile"):
		if Game.map.name == "Overworld":
			if $DetectTile.is_grass() == false:
				$DestructionTimer.start()
		elif Game.map.name == "Underworld":
			if $DetectTile.is_dirt() == false:
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
	if Game.map.terrain != null and is_instance_valid(Game.map.terrain):
		die_on_unstable_terrain()
		die_if_overlapping()
		#print(self.name, " Game.map.terrain == ", Game.map.terrain.name)
	else:
		push_warning(self.name + " Game.map.terrain not ready yet. Trying again in " + str($ScanTimer.get_wait_time()) + "s")
		$ScanTimer.start()



func _on_DestructionTimer_timeout():
	call_deferred("queue_free")

func receive_pizza():
	set_modulate(Color.white)
	#$CollisionShape2D.call_deferred("set_disabled", true)