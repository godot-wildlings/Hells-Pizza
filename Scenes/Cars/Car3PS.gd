extends RigidBody2D

onready var steering = $Steering
onready var engine = $Engine

var collision_in_progress : bool = false
var sinking_in_progress : bool = false

func _init():
	pass

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#warning-ignore:unused_argument
func _physics_process(delta):
	# hmm. setting linear velocity like this means we can't use apply_impulse to spin out.

	set_linear_velocity(Vector2.RIGHT.rotated(rotation) * engine.speed)

#	if has_node("Camera2D"):
#		var zoom_factor = lerp(1.0, 2.5, engine.speed / engine.max_speed)
#		$Camera2D.DesiredZoom = Vector2(zoom_factor, zoom_factor)

	#car.apply_impulse(position, Vector2.RIGHT.rotated(wheel_angle) * tire_grip * delta)
	var steering_factor : float = 0.005 # lower turns slower
	set_angular_velocity(steering.wheel_angle * engine.speed * steering_factor)

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

func _on_Car3PS_body_entered(body):
#	$CrashNoise.play()
	pass



func _on_HitStunTimer_timeout():
	pass # Replace with function body.
