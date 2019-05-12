extends KinematicBody2D

var direction = Vector2()
var speed = 0
var acceleration = 2600
var decceleration = 3000

var motion = Vector2()
var target_motion = Vector2()
var steering = Vector2()
const MASS = 2

const MAX_SPEED = 1200

var Skin = null
var target_angle = 0

func _ready():
	Skin = get_node("Sprite")


func _physics_process(delta):
	direction = Vector2.ZERO

	if Input.is_action_pressed("mv_up"):
		direction.y = -1
	elif Input.is_action_pressed("mv_down"):
		direction.y = 1

	if Input.is_action_pressed("mv_left"):
		direction.x = -1
	elif Input.is_action_pressed("mv_right"):
		direction.x = 1
	
	if direction != Vector2.ZERO:
		speed += acceleration * delta
	else:
		speed -= decceleration * delta

	speed = clamp(speed, 0, MAX_SPEED)
	print(speed)
	target_motion = speed * direction.normalized() * delta
	steering = target_motion - motion

	if steering.length() > 1:
		steering = steering.normalized()
	
	motion += steering / MASS

	if speed == 0:
		motion = Vector2.ZERO

	move_and_slide(motion)
	print(motion)
	if motion != Vector2.ZERO:
		target_angle = atan2(motion.x, motion.y) - PI / 2
		Skin.rotation = target_angle
