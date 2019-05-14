extends Node2D

export var acceleration : float = 250.0
export var deceleration : float = acceleration * 1.5
export var top_speed : float = 180.0 # mPh
var speed_conversion_factor : float = 6.0 # convert to pixels/s
var max_speed : float = top_speed * speed_conversion_factor # in pixels per second

export var num_gears : int = 5

var min_speed : float = -1 * top_speed / num_gears * speed_conversion_factor



export var max_fuel : float = 100.0
var fuel_remaining : float = max_fuel

var gear : int = 0 # zero is neutral

enum transmission_types { MANUAL, AUTOMATIC }
var transmission = transmission_types.AUTOMATIC

var velocity : Vector2 = Vector2.ZERO
var speed : float = 0.0 # This is what the car needs to know.

onready var throttle_noise : AudioStreamPlayer2D = get_node("ThrottleNoise")

var ticks : int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	throttle_noise.set_volume_db(-48)
	throttle_noise.play()


func gear_up():
	print(self.name, " gearing up." )
	gear = clamp(gear + 1, -1, num_gears)

func gear_down():
	print(self.name, " gearing down." )
	gear = clamp(gear - 1, -1, num_gears)

func _input(event):
	# reserved for manual gearing
	pass

func _physics_process(delta):
	ticks += 1
	if ticks % 60 == 0:
		print(self.name, " speed == ", speed)

	# report your vector to the car, so it can be relayed to the wheels
	if Input.is_action_pressed("accelerate"):
		throttle_noise.set_volume_db(-6)
		if speed < max_speed:
			speed += acceleration * delta
			check_gear()
	elif Input.is_action_pressed("decelerate"):
		if speed > min_speed:
			speed -= deceleration * delta
			check_gear()

	else:
		# idling at speed
		if abs(speed) > 0:
			throttle_noise.set_volume_db(-9)
		else:
			throttle_noise.set_volume_db(-12)

func check_gear():
	var gear_range : Array = [0, 0]
	gear_range[0] = max_speed / num_gears * (abs(gear) - 1)
	gear_range[1] = max_speed / num_gears * abs(gear)

	if ticks % 60 == 0:
		print("gear range == ", gear_range)

	# might need an exception for reverse gear (-1)
	if speed < gear_range[0]:
		gear_down()
	elif speed > gear_range[1] and gear < num_gears:
		gear_up()

	change_pitch(speed, gear_range)



func change_pitch(speed, gear_range):

	var pitch_factor = (speed - gear_range[0]) / (gear_range[1] - gear_range[0])

	if ticks % 60 == 0:
		print(self.name, " gear == ", gear )
		print(self.name, " pitch_factor == " , pitch_factor)
		print(self.name, " speed == ", speed)
		print(self.name, " max_speed == ", max_speed)

	throttle_noise.set_pitch_scale(lerp(0.5, 1.5, clamp(pitch_factor, 0, 1)))
