extends KinematicBody2D

var motion : Vector2 = Vector2()
var direction : Vector2 = Vector2()

var speed = 0
const MAX_SPEED = 600
const MASS = 2

var Skin = null
var target_angle = 0

export var acceleration = 1800
export var decceleration = 3000

func _ready():
	Skin = get_node("AnimatedSprite")
	set_physics_process(true)
	
func _physics_process(delta):
	
	direction = Vector2()
	
	if Input.is_action_pressed("w_key"):
		direction.y = -1
	elif Input.is_action_pressed("s_key"):
		direction.y = 1
	
	if Input.is_action_pressed("a_key"):
		direction.x = -1
	elif Input.is_action_pressed("d_key"):
		direction.x = 1
		
	if direction != Vector2():
		speed += acceleration * delta
	else:
		speed -= decceleration * delta
	
	speed = clamp(speed, 0, MAX_SPEED)
	
	
	motion = speed * direction.normalized()
	
	if motion != Vector2():
		target_angle = atan2(motion.x, motion.y) - PI/2
		Skin.set_rotation(target_angle)
	
	move_and_slide(motion)
	
	print(str(motion))