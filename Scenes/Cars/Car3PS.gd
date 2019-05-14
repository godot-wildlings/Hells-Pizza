extends RigidBody2D

onready var steering = $Steering
onready var engine = $Engine


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	set_linear_velocity(Vector2.RIGHT.rotated(rotation) * engine.speed)
