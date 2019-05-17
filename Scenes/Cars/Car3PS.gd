extends RigidBody2D

onready var steering = $Steering
onready var engine = $Engine

var collision_in_progress : bool = false
var sinking_in_progress : bool = false

enum states { on, off }
var state = states.off

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


	# hmm. setting linear velocity like this means we can't use apply_impulse to spin out.

	set_linear_velocity(Vector2.RIGHT.rotated(rotation) * engine.speed)


	#car.apply_impulse(position, Vector2.RIGHT.rotated(wheel_angle) * tire_grip * delta)
	#var steering_factor : float = 0.005 # lower turns slower
	var steering_factor : float = .01

	#set_angular_velocity(steering.wheel_angle * engine.speed * steering_factor)

	var spd = engine.speed
	var ratio = engine.speed / engine.max_speed

	# Nice ease out and back for lerping
	var eased_spd = sin(ratio*4)/2 + ratio
	# graph: https://www.desmos.com/calculator/ourez6xxg9


	var ang_vel = steering.wheel_angle * lerp(0, 6, eased_spd)

	set_angular_velocity(ang_vel)

#	print(engine.speed)
#	if engine.speed > 50:
#		set_angular_velocity(clamp(ang_vel, -6, 6))
#	else:
#		set_angular_velocity(lerp(get_angular_velocity(), 0.0, 0.6))

	detect_collisions()
	detect_lakes()

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