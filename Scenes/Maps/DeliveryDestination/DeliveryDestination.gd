extends Area2D

enum Types { TYPE_DEMON, TYPE_BUILDING }

onready var type : int = Types.TYPE_BUILDING
onready var building_container : Node2D = $Building
onready var demon_container : Node2D = $Demon
var is_current_destination : bool = false

var ticks : int = 0

func _ready():
	hide()
	$ScanTimer.start()
	if Game.map.name == "Underworld":
		type = Types.TYPE_DEMON
		$Label.text = "Demon"
	elif Game.map.name == "Overworld":
		type = Types.TYPE_BUILDING
		$Label.text = "Building"
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
		$RevealTimer.start()
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
	var random_key : String = _get_random_dict_key(Game.building_scenes)
	var random_scene : PackedScene = Game.building_scenes.get(random_key)
	for children in building_container.get_children():
		building_container.remove_child(children)
	var random_building : Building = random_scene.instance()
	building_container.add_child(random_building)

func _spawn_random_demon() -> void:
	assert Game.demon_scenes.size() > 0
	var random_key : String = _get_random_dict_key(Game.demon_scenes)
	var random_scene : PackedScene = Game.demon_scenes.get(random_key)
	for children in demon_container.get_children():
		demon_container.remove_child(children)
	var random_demon : Demon = random_scene.instance()
	demon_container.add_child(random_demon)
	random_demon.base_container = self

func _get_random_dict_key(dict : Dictionary) -> String:
	assert dict.size() > 0
	var random_key_idx : int = randi() % dict.size()
	var dict_keys : Array = dict.keys()
	var random_key : String = dict_keys[random_key_idx]
	assert dict.has(random_key)

	return random_key

func die():
	call_deferred("queue_free")

func _on_DestructionTimer_timeout():
	die()

func request_pizza():
	for building in building_container.get_children():
		if building.has_node("DestinationAura"):
			building.get_node("DestinationAura").show()
	for demon in demon_container.get_children():
		if demon.has_node("DestinationAura"):
			demon.get_node("DestinationAura").show()

func reject_pizza():
	var rejection_idx = randi()%$rejections.get_child_count()
	var rejection = $rejections.get_children()[rejection_idx]
	rejection.set_pitch_scale(rand_range(0.66, 1.33))
	rejection.play()

func receive_pizza():
	for building in building_container.get_children():
		if building.has_node("DestinationAura"):
			building.get_node("DestinationAura").hide()
	for demon in demon_container.get_children():
		if demon.has_node("DestinationAura"):
			demon.get_node("DestinationAura").hide()

	$ThanksNoise.set_pitch_scale(rand_range(0.75, 1.33))
	$ThanksNoise.play()

	var tip = rand_range(0.05, 0.50)
	if Game.map.name == "Underworld":
		tip *= 5.0
	Game.player.receive_tip(tip)

	#$CollisionShape2D.call_deferred("set_disabled", true)

func get_coordinates() -> Vector2:
	if Game.map.name == "Underworld":
		# imps can move when the player hits them
		# compass needs to know where the imp is.
		return $Demon.get_child(0).get_global_position()
	else:
		return get_global_position()


func _on_RevealTimer_timeout():
	show()
