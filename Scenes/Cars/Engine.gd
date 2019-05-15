extends Node2D

export var acceleration : float = 250.0
export var deceleration : float = acceleration * 1.5
export var top_speed : float = 180.0 # mPh
var speed_conversion_factor : float = 6.0 # convert to pixels/s
var max_speed : float = top_speed * speed_conversion_factor # in pixels per second

export var num_gears : int = 5

var min_speed : float = -1 * top_speed / num_gears * speed_conversion_factor



export var max_fuel : float = 100.0

#warning-ignore:unused_class_variable
var fuel_remaining : float = max_fuel

var gear : int = 0 # zero is neutral

#warning-ignore:unused_class_variable
enum transmission_types { MANUAL, AUTOMATIC }
var transmission = transmission_types.AUTOMATIC

#warning-ignore:unused_class_variable
var velocity : Vector2 = Vector2.ZERO
var speed : float = 0.0 # This is what the car needs to know.

onready var throttle_noise : AudioStreamPlayer2D = get_node("ThrottleNoise")
onready var car : KinematicBody2D

var ticks : int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	throttle_noise.set_volume_db(-48)
	throttle_noise.play()
	car = get_parent()

func gear_up():
	#print(self.name, " gearing up." )
	gear = int(clamp(gear + 1, -1, num_gears))

func gear_down():
	#print(self.name, " gearing down." )
	gear = int(clamp(gear - 1, -1, num_gears))

#warning-ignore:unused_argument
func _input(event):
	# reserved for manual gearing
	pass

func _physics_process(delta):
	ticks += 1

	# report your vector to the car, so it can be relayed to the wheels
	if Input.is_action_pressed("accelerate"):
		throttle_noise.set_volume_db(-15)
		if speed < max_speed:
			speed += acceleration * delta
			check_gear()
			apply_engine_impulse(delta)
	elif Input.is_action_pressed("decelerate"):
		if speed > min_speed:
			speed -= deceleration * delta
			check_gear()
			apply_engine_impulse(delta)
	else:
		# idling at speed
		if abs(speed) > 40:
			throttle_noise.set_volume_db(-25)
		else:
			throttle_noise.set_volume_db(-40)

#warning-ignore:unused_argument
func apply_engine_impulse(delta):
	#car.apply_impulse(position, Vector2.RIGHT.rotated(car.rotation) * speed * delta)
	pass # using impulses feels like a spaceship

func check_gear():
	var gear_range : Array = [0, 0]
	gear_range[0] = max_speed / num_gears * (abs(gear) - 1)
	gear_range[1] = max_speed / num_gears * abs(gear)

	# might need an exception for reverse gear (-1)
	if speed < gear_range[0]:
		gear_down()
	elif speed > gear_range[1] and gear < num_gears:
		gear_up()

	change_pitch(speed, gear_range)



func change_pitch(speed, gear_range):

	var pitch_factor = (speed - gear_range[0]) / (gear_range[1] - gear_range[0])

#	if ticks % 60 == 0:
#		print(self.name, " gear == ", gear )
#		print(self.name, " pitch_factor == " , pitch_factor)
#		print(self.name, " speed == ", speed)
#		print(self.name, " max_speed == ", max_speed)

	throttle_noise.set_pitch_scale(lerp(0.5, 1.5, clamp(pitch_factor, 0, 1)))


func set_top_speed(speed : float):
	top_speed = speed
	max_speed = top_speed * speed_conversion_factor

