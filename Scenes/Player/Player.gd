"""
Note. Player is independent of Car, because we might want players to be able to switch cars.

"""

extends Node2D


#warning-ignore:unused_class_variable
var current_destination


enum states { walking, driving, paused, dead }
var state = states.paused

var cash : float = 0.0
onready var tip_tracker = $CanvasLayer/TipTracker

var pizza_ammo : int = 0
var car : Node2D # probably rigidbody, but we might switch to kinematic



signal met_the_devil(cash_on_hand)
signal met_mom_in_hell()
signal found_exit_from_hell()

func _init():
	Game.player = self

func _ready():
	call_deferred("deferred_ready")

func deferred_ready():


	$WalkingSprite.hide()
	current_destination = Game.map.pizza_factory
	#warning-ignore:return_value_discarded
	connect("met_the_devil", Game.main, "_on_Player_met_the_devil")
	#warning-ignore:return_value_discarded
	connect("met_mom_in_hell", Game.main, "_on_Player_met_mom_in_hell")
	#warning-ignore:return_value_discarded
	connect("found_exit_from_hell", Game.main, "_on_Player_found_exit_from_hell")

func get_in_car(car_node):
	if is_instance_valid(get_parent()):
		get_parent().remove_child(self)
	car_node.add_pilot(self)
	car = car_node

	state = states.driving
	car.turn_on()

	$PizzaCompass.turn_on()
	$DevilCompass.turn_on()
	$MomCompass.turn_on()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func deliver_pizza(area):
	if area.has_method("receive_pizza"):
		# get your tip, set the compass back to the pizza factory
		print("You delivered a pizza!")
		cash += rand_range(0.05, 0.50)
		current_destination = Game.map.pizza_factory
		area.receive_pizza()

func get_new_destination():
#	print("old destination == ", current_destination)

	if current_destination.has_method("deactivate"):
		print("deactivating ", current_destination.name)
		current_destination.deactivate()
	if pizza_ammo > 0:
		var i : int = 0
		var new_destination = current_destination

		# prevent going to the same place twice
		while new_destination == current_destination and i < 25:
			new_destination = Game.map.pizza_factory.get_random_destination()
			i += 1
		current_destination = new_destination
	else:
		current_destination = Game.map.pizza_factory
#	print("new destination == ", current_destination)
#	print("===========================================")

func drop_pizza():
	if pizza_ammo > 0:
		var vel = Vector2.ZERO
		var speed = 50
		if state == states.driving:
			vel += Vector2.RIGHT.rotated(get_parent().rotation) * speed
		throw_pizza(vel)

func throw_pizza(velocity):
	var vel = velocity
	var pizza_scene = load("res://Scenes/Projectiles/Pizza.tscn")
	var new_pizza = pizza_scene.instance()
	$Projectiles.add_child(new_pizza)
	new_pizza.set_as_toplevel(true)
	var pos = get_global_position()
	if state == states.driving:
		if get_parent().is_in_group("cars"):
			vel += get_parent().get_linear_velocity()

	new_pizza.start(pos, vel)
	pizza_ammo -= 1
	$PizzaNoise.play()

	if pizza_ammo <= 0:
		current_destination = Game.map.pizza_factory

func receive_tip(value):
	if value > 0:
		$TipPopup/Panel/TipAmount.set_text("%6.2f"%value)
		$TipPopup/AnimationPlayer.play("popup_tip")
		cash += value
	get_new_destination()


#warning-ignore:unused_argument
func _unhandled_input(event):
	if (
			Input.is_action_just_pressed("shoot")
			and state != states.dead
			and state != states.paused
	):
		if pizza_ammo > 0:
			var pos = get_global_position()
			var speed = 1250.0
			var vel = (get_global_mouse_position() - pos).normalized() * speed
			throw_pizza(vel)


	if Input.is_action_just_pressed("cheat_show_compasses"):
		$PizzaCompass.cheat_enabled = true
		$DevilCompass.cheat_enabled = true
		$MomCompass.cheat_enabled = true



func pickup_pizzas():
	var max_pizzas :int  = 13
	if pizza_ammo < max_pizzas:
		pizza_ammo = max_pizzas
		$HurryNoise.play()

		if tip_tracker.has_method("reset_clock"):
			tip_tracker.reset_clock()
		print(self.name, " current destination == ", current_destination.name )
		if current_destination != Game.map.pizza_factory:
			current_destination.deactivate()
		get_new_destination()

func meet_the_devil():
	if state == states.driving:
		car.turn_off()

		emit_signal("met_the_devil", cash)

func meet_mom_in_hell(mom):
	if state == states.driving:
		car.turn_off()

	if mom.has_method("die"):
		mom.die()

	$MomCompass.target = $MomCompass.targets.EXIT
	emit_signal("met_mom_in_hell")

#warning-ignore:unused_argument
func exit_hell(exit):
	if state == states.driving:
		car.turn_off()
	emit_signal("found_exit_from_hell")

func _on_DestinationDetector_area_entered(area):
	if area == Game.devil:
		meet_the_devil()

	elif area.name == "Mom":
		meet_mom_in_hell(area)

	elif area.name == "Exit":
		exit_hell(area)

	elif area == Game.map.pizza_factory:
		pickup_pizzas()



