extends RigidBody2D

onready var steering = $Steering
onready var engine = $Engine


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#warning-ignore:unused_argument
func _physics_process(delta):
	# hmm. setting linear velocity like this means we can't use apply_impulse to spin out.

	set_linear_velocity(Vector2.RIGHT.rotated(rotation) * engine.speed)

	if has_node("Camera2D"):
		var zoom_factor = lerp(1.0, 2.5, engine.speed / engine.max_speed)
		$Camera2D.DesiredZoom = Vector2(zoom_factor, zoom_factor)

	#car.apply_impulse(position, Vector2.RIGHT.rotated(wheel_angle) * tire_grip * delta)
	var steering_factor : float = 0.005 # lower turns slower
	set_angular_velocity(steering.wheel_angle * engine.speed * steering_factor)