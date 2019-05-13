extends Node

onready var loops = $Loops

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func play_random_loop():
	loops.get_child(randi()%loops.get_child_count()).play()


func _on_BGMusicIntro_finished():
	play_random_loop()


func _on_BGMusicLoop_finished():
	play_random_loop()
