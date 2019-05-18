extends Area2D

var velocity : Vector2 = Vector2.ZERO
enum states { ready, delivered }
var state = states.ready

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start(pos, vel):
	set_global_position(pos)
	velocity = vel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_global_position(get_global_position() + velocity * delta)

func die():
	$Sprite.hide()
	$CollisionShape2D.call_deferred("set_disabled", true)
	call_deferred("queue_free")


func _on_Timer_timeout():
	call_deferred("die")


func deliver_pizza(area):
	if area.has_method("receive_pizza"):
		# get your tip, set the compass back to the pizza factory
		print("You delivered a pizza!")
		#Game.player.current_destination = Game.map.pizza_factory
		Game.player.get_new_destination()
		area.receive_pizza()
		state = states.delivered


func _on_Pizza_area_entered(area):
	if state == states.ready:
		if area == Game.player.current_destination:
			deliver_pizza(area)
			die()
		elif area.has_method("reject_pizza"):
			area.reject_pizza()
			die()
