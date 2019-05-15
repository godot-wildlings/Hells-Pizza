extends Node2D
export var num_destinations : int = 500
export var max_distance : float = 25000

func _ready():
	call_deferred("spawn_houses")


func spawn_houses():
	#warning-ignore:unused_variable
	for i in range(num_destinations):
		spawn_delivery_destination()


func spawn_delivery_destination():


	var destination_scene = load("res://Scenes/Maps/DeliveryDestination/DeliveryDestination.tscn")
	var new_destination = destination_scene.instance()

	var player_pos = Game.player.get_global_position()
	var distance : float = rand_range(250, max_distance)
	var direction : float = rand_range(0, 2*PI)
	var max_distance : float = 1000
	var new_position = player_pos + Vector2.RIGHT.rotated(direction) * distance
	add_child(new_destination)
	new_destination.set_global_position(new_position)






