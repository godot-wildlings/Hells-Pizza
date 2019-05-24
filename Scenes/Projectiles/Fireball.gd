extends Area2D

var velocity : Vector2 = Vector2.ZERO
enum states { ready, delivered }
var state = states.ready

# Called when the node enters the scene tree for the first time.
func _ready():
	$LaunchNoise.play()

func start(pos, vel):
	set_as_toplevel(true)
	set_global_position(pos)
	velocity = vel
	 # don't move with the demon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_global_position(get_global_position() + velocity * delta)

func die():
	$Sprite.hide()
	$CollisionShape2D.call_deferred("set_disabled", true)
	call_deferred("queue_free")

func disappear():
	$Sprite.hide()
	$CollisionShape2D.call_deferred("set_disabled", true)

func _on_Timer_timeout():
	call_deferred("die")





func _on_Fireball_body_entered(body):
	if state == states.ready:
		if body == Game.player.car:
			if body.has_method("hit"):
				var damage : int = 10
				body.hit(damage)
				$ImpactNoise.play()
				disappear()


func _on_ImpactNoise_finished():
	die()
