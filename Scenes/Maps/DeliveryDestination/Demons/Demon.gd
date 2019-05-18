extends Area2D

class_name Demon

enum states { dead, passive, aggressive }
var state = states.passive

var base_container : Area2D
var current_target : Node2D # probably the player


func explode():
	$Death/DeathTimer.start()
	$AnimationPlayer.play("explode")
	state = states.dead


func _on_Demon_body_entered(body):
	if state != states.dead:
		if body == Game.player.car:
			explode()

func aggro(object):
	current_target = object # probably the player
	state = states.aggressive
	$AttackTimer.start()

func attack(target):
	if state == states.aggressive:
		var max_range_sq = 750 * 750
		var my_pos = get_global_position()
		var target_pos = target.get_global_position()
		if my_pos.distance_squared_to(target_pos) < max_range_sq:
			var fireball_scene = preload("res://Scenes/Projectiles/Fireball.tscn")
			var new_fireball = fireball_scene.instance()
			$Fireballs.add_child(new_fireball)

			var speed : float = 600.0
			var vel = (target_pos - my_pos).normalized() * speed
			vel = vel.rotated(rand_range(-0.5, 0.5))
			new_fireball.start(my_pos, vel)
		$AttackTimer.set_wait_time(rand_range(0.2, 1.0))
		$AttackTimer.start()


func die():
	base_container.die()


func _on_DeathTimer_timeout():
	die()

func _on_AttackTimer_timeout():
	attack(current_target)
