extends Area2D

class_name Demon

enum states { alive, dead }
var state = states.alive

var base_container : Area2D

func explode():
	$Death/DeathTimer.start()
	$AnimationPlayer.play("explode")


func _on_Demon_body_entered(body):
	if state == states.alive:
		if body == Game.player.car:
			explode()


func die():
	base_container.die()


func _on_DeathTimer_timeout():
	die()
