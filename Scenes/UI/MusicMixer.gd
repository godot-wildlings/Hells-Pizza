extends Node

#onready var loops = $Loops
onready var underworld_loops = $UnderworldLoops
onready var overworld_loops = $OverworldLoops

var current_song_index : int = -1

var current_loop_container : Node

signal song_changed(song_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	set_volume(-22)

	if Game.map.name == "Overworld":
		current_loop_container = overworld_loops
	elif Game.map.name == "Underworld":
		current_loop_container = underworld_loops

func set_volume(vol):
	for loop_container in get_children():
		for loop in loop_container.get_children():
			if loop.has_method("set_volume_db"):
				loop.set_volume_db(vol)


func stop_all_songs():
	for loop_container in get_children():
		for loop in loop_container.get_children():
			if loop.has_method("stop"):
					loop.stop()

func play_song(index_num):
	stop_all_songs()
	var num_songs = current_loop_container.get_child_count()
	var track_num = wrapi(index_num, 0, num_songs)
	var audio_player_node = current_loop_container.get_child(track_num)
	audio_player_node.play()
	current_song_index = track_num
	return str(audio_player_node.name)


func play_next_song() -> String:
	return play_song(current_song_index + 1)

func play_current_song() -> String:
	return play_song(current_song_index)

func play_last_song() -> String:
	return play_song(current_song_index - 1)


func play_random_loop() -> String:
	var track_num = randi()%current_loop_container.get_child_count()
	return play_song(track_num)


func _on_BGMusicLoop_finished() -> void:
	var song_name = play_random_loop()
	emit_signal("song_changed", song_name)


func pause():
	stop_all_songs()