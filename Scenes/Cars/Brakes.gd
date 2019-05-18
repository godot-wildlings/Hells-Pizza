extends Node2D

onready var car : KinematicBody2D

var braking_factor : float = 1.0

enum states { on, off }
var state = states.off


# Called when the node enters the scene tree for the first time.
func _ready():
	car = get_parent()

#warning-ignore:unused_argument
func _physics_process(delta):
	if Input.is_action_just_pressed("brake") and abs(car.engine.speed) > 350:
		state = states.on
		braking_factor = 1.25
		$SkidMarkTimer.start()

		if not $ScreechNoise.is_playing():
			$ScreechNoise.set_pitch_scale(rand_range(0.8, 1.25))
			$ScreechNoise.play()

	if Input.is_action_just_released("brake"):
		state = states.off
		braking_factor = 1.0



func spawn_tire_tracks():
	var tracks_scene = preload("res://Scenes/Consumables/TireTrack.tscn")
	var new_tracks = tracks_scene.instance()
	Game.map.get_node("TireTracks").add_child(new_tracks)
	#new_tracks.set_as_toplevel(true)
	new_tracks.set_global_position(get_global_position())
	new_tracks.set_global_rotation(get_global_rotation())





func _on_SkidMarkTimer_timeout():

	if state == states.on:
		spawn_tire_tracks()
		$SkidMarkTimer.start()
