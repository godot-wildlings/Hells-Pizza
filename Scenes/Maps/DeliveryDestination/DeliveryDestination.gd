extends Area2D

enum Types { TYPE_DEMON, TYPE_BUILDING }

onready var type : int = Types.TYPE_BUILDING
onready var building_container : Node2D = $Building
onready var demon_container : Node2D = $Demon

func _ready():
	$ScanTimer.start()
	if Game.map.name == "Underworld":
		type = Types.TYPE_DEMON
	elif Game.map.name == "Overworld":
		type = Types.TYPE_BUILDING
	_spawn_entity_based_on_type()

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


func _on_ScanTimer_timeout():
	if Game.map.terrain != null and is_instance_valid(Game.map.terrain):
		die_on_unstable_terrain()
		die_if_overlapping()
		#print(self.name, " Game.map.terrain == ", Game.map.terrain.name)
	else:
		push_warning(self.name + " Game.map.terrain not ready yet. Trying again in " + str($ScanTimer.get_wait_time()) + "s")
		$ScanTimer.start()

func _spawn_entity_based_on_type() -> void:
	match self.type:
		Types.TYPE_BUILDING:
			_spawn_random_building()
		Types.TYPE_DEMON:
			_spawn_random_demon()

func _spawn_random_building() -> void:
	assert Game.building_scenes.size() > 0
	var random_key_idx : int = randi() % Game.building_scenes.size()
	var building_scenes_keys : Array = Game.building_scenes.keys()
	var random_key : String = building_scenes_keys[random_key_idx]
	assert Game.building_scenes.has(random_key)
	var random_scene : PackedScene = Game.building_scenes.get(random_key)
	for children in building_container.get_children():
		building_container.remove_child(children)
	var random_building : Building = random_scene.instance()
	building_container.add_child(random_building)

func _spawn_random_demon() -> void:
	pass

func _on_DestructionTimer_timeout():
	call_deferred("queue_free")

func receive_pizza():
	set_modulate(Color.white)
	#$CollisionShape2D.call_deferred("set_disabled", true)