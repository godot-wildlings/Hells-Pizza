"""
Mom will be located somewhere in the underworld.
If you find her, it prompts a cutscene, and a race to safety.

"""

extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Game.mom = self

func start():

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

func die():
	hide()
	$CollisionShape2D.call_deferred("set_disabled", true)
	call_deferred("queue_free")
