extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.devil = self

func start():
	find_safe_location()


func find_safe_location():
	var safe = false
	var i : int = 0
	while safe == false and i < 500:
		i += 1
		var distance_from_origin = 4500
		var rand_direction = randf()*2*PI
		set_global_position(Vector2.RIGHT.rotated(rand_direction) * distance_from_origin)
		if $DetectTile.is_safe():
			safe = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
