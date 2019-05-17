extends Area2D

func _ready():
	Game.devil = self

func start():
	find_safe_location()


func find_safe_location():
	var safe = false
	var i : int = 0
	while safe == false and i < 500:
		i += 1
		var distance_from_origin = rand_range(250, 2000)
		var rand_direction = randf()*2*PI
		set_global_position(Vector2.RIGHT.rotated(rand_direction) * distance_from_origin)
		if $DetectTile.is_safe():
			safe = true
