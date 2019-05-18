extends Area2D



func start():
	Game.exit = self
	Game.player.current_destination == self

	var safe_location = false
	var i : int = 0
	while safe_location == false and i < 500:
		move_to_random_location()
		if $DetectTile.is_safe() == true:
			safe_location = true
		i += 1

func move_to_random_location():
	var rand_distance = rand_range(2500, 4500)
	var rand_dir = rand_range(0, 2*PI)
	var pos = Vector2.RIGHT.rotated(rand_dir) * rand_distance
	set_global_position(Game.player.get_global_position() + pos)
