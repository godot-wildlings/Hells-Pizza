extends Area2D

enum Types { TYPE_DEMON, TYPE_BUILDING }

onready var type : int = Types.TYPE_BUILDING
onready var building_container : Node2D = $Building
onready var demon_container : Node2D = $Demon

var my_building

#var is_current_destination : bool = false

# movement stuff for demons
var my_demon
var direction : float = 0.0
var speed : float = 200.0
var time_elapsed : float = 0.0
var current_target : Node2D # probably the player

enum states { hungry, fed }
var state = states.hungry


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
	my_building = random_building




func _spawn_random_demon() -> void:
	assert Game.demon_scenes.size() > 0
	var random_key : String = _get_random_dict_key(Game.demon_scenes)
	var random_scene : PackedScene = Game.demon_scenes.get(random_key)
	for children in demon_container.get_children():
		demon_container.remove_child(children)
	var random_demon : Demon = random_scene.instance()
	demon_container.add_child(random_demon)
	random_demon.base_container = self
	my_demon = random_demon

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


func _physics_process(delta):
	time_elapsed += delta
	if type == Types.TYPE_DEMON:
		if my_demon.state != my_demon.states.dead:
			move_around_like_a_demon(delta)

	# HAX: building's aren't deactivating properly when pizzas are picked up and delivered
	if Game.ticks % 30 == 0:
		var aura
		if Game.map.name == "Overworld":
			aura = my_building.get_node("DestinationAura")
		elif Game.map.name == "Underworld":
			aura = my_demon.get_node("DestinationAura")
		if aura.is_visible() and Game.player.current_destination != self:
			aura.hide()



func move_around_like_a_demon(delta):
	if $MoveTimer.is_stopped():
		$MoveTimer.start()

	var my_pos = get_global_position()

	var velocity : Vector2
	if my_demon.state == my_demon.states.passive:
		velocity = Vector2.RIGHT.rotated(direction) * speed + Vector2.UP.rotated(direction) * speed * sin(time_elapsed)
	elif my_demon.state == my_demon.states.aggressive:
		velocity = (current_target.get_global_position() - my_pos).normalized() * speed / 2 + Vector2.RIGHT.rotated(direction) * speed + Vector2.UP.rotated(direction) * speed/2 * sin(time_elapsed)

	set_global_position(my_pos + velocity * delta)

func aggro(object):
	current_target = object
	if my_demon.has_method("aggro"):
		my_demon.aggro(object)



func _on_MoveTimer_timeout():
	direction = rand_range(0, 2*PI)
	$MoveTimer.set_wait_time(rand_range(1, 2.5))
	$MoveTimer.start()

func request_pizza():
	if Game.map.name == "Overworld":
		my_building.get_node("DestinationAura").show()
	elif Game.map.name == "Underworld":
		my_demon.get_node("DestinationAura").show()

#	for building in building_container.get_children():
#		if building.has_node("DestinationAura"):
#			building.get_node("DestinationAura").show()
#	for demon in demon_container.get_children():
#		if demon.has_node("DestinationAura"):
#			demon.get_node("DestinationAura").show()

func deactivate():
	call_deferred("hide_delivery_auras")


func reject_pizza():
	if state == states.hungry:
		var rejection_idx = randi()%$rejections.get_child_count()
		var rejection = $rejections.get_children()[rejection_idx]
		rejection.set_pitch_scale(rand_range(0.66, 1.33))
		rejection.play()

		state = states.fed
		$HitStunTimer.start()

func receive_pizza():
#	print(self.name, " receiving pizza" )
#	print(self.name, " children in Building node: ", $Building.get_child_count())
#	print(self.name, " state == ", state)

	if state == states.fed:
		return
	else:
		hide_delivery_auras()
		pay_tip()
		$HitStunTimer.start()
		state = states.fed


func hide_delivery_auras():
	if Game.map.name == "Overworld":
		my_building.get_node("DestinationAura").hide()
	elif Game.map.name == "Underworld":
		my_demon.get_node("DestinationAura").hide()


func pay_tip():
	var tip : float
	if Game.player.tip_tracker.time_remaining > 0:
		tip = rand_range(0.05, 0.50)
		$ThanksNoise.set_pitch_scale(rand_range(0.75, 1.33))
		$ThanksNoise.play()
		if Game.map.name == "Underworld":
			tip *= 5.0
		Game.player.receive_tip(tip)
	else:
		tip = 0
		$LateNoise.set_pitch_scale(rand_range(0.75, 1.33))
		$LateNoise.play()
		Game.player.receive_tip(0)




func get_coordinates() -> Vector2:
	if Game.map.name == "Underworld":
		# imps can move when the player hits them
		# compass needs to know where the imp is.
		return $Demon.get_child(0).get_global_position()
	else:
		return get_global_position()


func _on_RevealTimer_timeout():
	show()


func _on_HitStunTimer_timeout():
	state = states.hungry
