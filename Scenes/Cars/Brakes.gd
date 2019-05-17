extends Node2D

onready var car : KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	car = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("brake"):
		# what should happen?
		# if it's rear wheel drive and front wheel steering,
		# locking the front wheels should cause a spinout

		var fudge_factor : float = 2800.0
		var spin_impulse_vector = Vector2.RIGHT.rotated(car.rotation) * sign(car.get_angular_velocity()) * fudge_factor
		print(self.name, " spin_impulse_vector == ", spin_impulse_vector )
		car.apply_impulse(position, spin_impulse_vector * delta)
		# impulses don't work if we're constantly setting the velocity



