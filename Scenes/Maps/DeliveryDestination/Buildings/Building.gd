extends StaticBody2D

class_name Building

#onready var delivery_destination : Area2D = $DeliveryDestination
#
#func _process(delta : float) -> void:
#	if Game.map.name == "Underworld":
#		visible = false
#		delivery_destination.disabled = true