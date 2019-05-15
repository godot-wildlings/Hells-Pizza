extends Control

onready var play_button = get_node("VBoxContainer/HBoxContainer/PlayButton")
onready var pause_button = get_node("VBoxContainer/HBoxContainer/PauseButton")
onready var music_mixer = get_node("VBoxContainer/HBoxContainer/MusicMixer")
onready var song_name_label = get_node("VBoxContainer/SongNameLabel")


func _ready():
	play_button.show()
	pause_button.hide()

	music_mixer.connect("song_changed", self, "_on_song_changed")



func _on_VolSlider_value_changed(value):
	var music_bus = 1
	AudioServer.set_bus_volume_db(music_bus, linear2db(value))

func update_song_label(song_name : String):
	song_name_label.set_text(song_name)

func _on_NextSongButton_pressed():
	var song_name = music_mixer.play_next_song()
	update_song_label(song_name)
	play_button.hide()
	pause_button.show()


func _on_PauseButton_pressed():
	music_mixer.pause()
	pause_button.hide()
	play_button.show()



func _on_PlayButton_pressed():
	var song_name = music_mixer.play_current_song()
	update_song_label(song_name)
	play_button.hide()
	pause_button.show()


func _on_PrevSongButton_pressed():
	var song_name = music_mixer.play_last_song()
	update_song_label(song_name)

	play_button.hide()
	pause_button.show()

func _on_song_changed(song_name):
	update_song_label(song_name)