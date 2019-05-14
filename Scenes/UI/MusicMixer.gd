extends Node

onready var loops = $Loops

# Called when the node enters the scene tree for the first time.
func _ready():
	set_volume(-40)

func set_volume(vol):
	$BGMusicIntro.set_volume_db(vol)
	for loop in loops.get_children():
		loop.set_volume_db(vol)


func play_random_loop():
	var track_num = randi()%loops.get_child_count()
	print(self.name , " playing: ", loops.get_child(track_num).name )
	loops.get_child(track_num).play()


func _on_BGMusicIntro_finished():
	play_random_loop()


func _on_BGMusicLoop_finished():
	play_random_loop()
