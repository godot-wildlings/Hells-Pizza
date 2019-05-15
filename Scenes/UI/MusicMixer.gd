extends Node

onready var loops = $Loops
var current_song_index : int = -1

signal song_changed(song_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	set_volume(-22)

func set_volume(vol):
	for loop in loops.get_children():
		loop.set_volume_db(vol)


func stop_all_songs():
	for loop in $Loops.get_children():
		if loop.is_playing():
			loop.stop()

func play_song(index_num):
	stop_all_songs()
	var num_songs = $Loops.get_child_count()
	var track_num = wrapi(index_num, 0, num_songs)
	var audio_player_node = loops.get_child(track_num)
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
	var track_num = randi()%loops.get_child_count()
	return play_song(track_num)


func _on_BGMusicLoop_finished() -> void:
	var song_name = play_random_loop()
	emit_signal("song_changed", song_name)


func pause():
	stop_all_songs()