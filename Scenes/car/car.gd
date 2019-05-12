extends KinematicBody2D

var direction : Vector2 = Vector2()
var speed : float = 0
var acceleration : float = 1800
var decceleration = 3000

var motion : Vector2 = Vector2()
var target_motion : Vector2 = Vector2()
var steering : Vector2 = Vector2()
const MASS = 2

const MAX_SPEED = 600

var Skin = null
var target_angle = 0

func _ready():
	Skin = get_node("AnimatedSprite")
	set_physics_process(true)

func _physics_process(delta):
	
	direction = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	elif Input.is_action_pressed("ui_down"):
		direction.y = 1
	
	
	if Input.is_action_pressed("ui_left"):
		direction.x = -1
	elif Input.is_action_pressed("ui_right"):
		direction.x = 1
	
	if direction != Vector2():
		speed += acceleration * delta
	else:
		speed -= decceleration * delta
	
	speed = clamp(speed, 0, MAX_SPEED)
	
	target_motion = speed * direction.normalized() * delta
	steering = target_motion - motion
	
	if steering.length() > 1:
		steering = steering.normalized()
	
	motion += steering / MASS
	
	if speed == 0:
		motion = Vector2()
	
	if motion != Vector2():
		target_angle = atan2(motion.x, motion.y) - PI/2
		Skin.set_rotation(target_angle)
	
	move_and_slide(motion)