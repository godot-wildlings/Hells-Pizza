extends Node2D
export var num_destinations : int = 150
export var max_distance : float = 15000

func _ready():
	randomize()
	call_deferred("spawn_houses")


func spawn_houses():
	#warning-ignore:unused_variable
	for i in range(num_destinations):
		spawn_delivery_destination()


func spawn_delivery_destination():


	var destination_scene = load("res://Scenes/Maps/DeliveryDestination/DeliveryDestination.tscn")
	var new_destination = destination_scene.instance()

	var initial_offset = Vector2.ZERO
	var distance : float = rand_range(750, max_distance)
	var direction : float = rand_range(0, 2*PI)
	var max_distance : float = 1000
	var new_position = initial_offset + Vector2.RIGHT.rotated(direction) * distance
	add_child(new_destination)
	new_destination.set_global_position(new_position)


func aggro_demons():
	print(self.name, " aggroing demons now")
	for destination in get_children():
		if destination.has_method("aggro"):
			destination.aggro(Game.player)



