extends RigidBody2D

onready var steering = $Steering
onready var engine = $Engine
onready var radio = $CanvasLayer/Radio
var collision_in_progress : bool = false
var sinking_in_progress : bool = false

export var health : int = 100


enum states { on, off }
var state = states.off

var terrain_speed_reduction = 1.0 # changes in detect_bumps()

func _init():
	pass

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#warning-ignore:unused_argument
func _physics_process(delta):
	if state == states.off:
		return

	var spd = engine.speed * terrain_speed_reduction

	set_linear_velocity(Vector2.RIGHT.rotated(rotation) * spd)
	#var steering_factor : float = .01
	var ratio = spd / engine.max_speed

	# Nice ease out and back for lerping
	var eased_spd = sin(ratio*4)/2 + ratio
	# graph: https://www.desmos.com/calculator/ourez6xxg9

	var ang_vel = steering.wheel_angle * lerp(0, 6, eased_spd)
	set_angular_velocity(ang_vel)

	detect_collisions()
	detect_lakes()
	detect_bumps()

func detect_bumps():
	if state == states.off:
		if $BumpyNoise.is_playing():
			$BumpyNoise.stop()
		return

	if Game.map.name == "Overworld":
		if $DetectTile.is_asphalt() == true:
			if $BumpyNoise.is_playing():
				$BumpyNoise.stop()
			terrain_speed_reduction = 1.0
		else: # not on asphalt.
			if $BumpyNoise.is_playing() == false:
				$BumpyNoise.play()

		if $DetectTile.is_grass():
			terrain_speed_reduction = 0.66
			$BumpyNoise.set_volume_db(-15)
		elif $DetectTile.is_dirt():
			terrain_speed_reduction = 0.50
			$BumpyNoise.set_volume_db(-9)
			$BumpyNoise.set_pitch_scale(0.8)




func detect_collisions():
	var collisions = get_colliding_bodies()
	if collisions.size() == 0:
		collision_in_progress = false
	elif (
			collision_in_progress == false
			and collisions.size() > 0
			and engine.speed > 100
	):
		$CrashNoise.play()
		collision_in_progress = true
		engine.speed = 0.0
		Game.player.drop_pizza()

func detect_lakes():
	if not $DetectTile.is_safe():
		if sinking_in_progress == false:
			engine.speed = 0.0
			$SplashNoise.play()
			sinking_in_progress = true
			engine.set_top_speed(20)
	else: # safe
		if sinking_in_progress == true:
			sinking_in_progress = false
			engine.set_top_speed(180)




func _on_HitStunTimer_timeout():
	pass # Replace with function body.

func shut_off():
	engine.shut_off()
	radio.shut_off()
	state = states.off

func turn_off():
	shut_off()


func turn_on():
	$IgnitionTimer.start()
	$IgnitionNoise.play()


func add_driver(driver_node):
	add_pilot(driver_node)

func add_pilot(pilot_node):
	add_child(pilot_node)

func _on_IgnitionTimer_timeout():
	engine.turn_on()
	state = states.on

func _integrate_forces(state):
	state.get_transform()

func _on_IgnitionNoise_finished():
	# turn on the radio..
	$CanvasLayer/Radio.turn_on()
	$"CanvasLayer/Radio"._on_NextSongButton_pressed()

func hit(damage):
	health -= damage
	# should probably illustrate this with visible crash damage
