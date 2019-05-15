extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_random_destination() -> Area2D:
	if Game.map.has_node("DeliveryDestinations"):
		var destination = Game.map.get_node("DeliveryDestinations").get_children()[randi()%get_child_count()]
		destination.set_modulate(Color.lightgreen)
		return destination
	else:
		push_error("Map needs an instance of DeliveryDestinations.tscn so we can delivery pizzas.")
		return null
