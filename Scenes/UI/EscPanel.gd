extends PopupPanel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/QuitScreen.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_QuitButton_pressed():
	Game.main.play_click_noise()
	$MarginContainer/QuitScreen.show()
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().quit()


func _on_ResumeButton_pressed():
	Game.main.play_click_noise()
	hide()





func _on_EscPanel_about_to_show():
	get_tree().set_pause(true)


func _on_EscPanel_popup_hide():
	get_tree().set_pause(false)


func _on_Button_hover():
	Game.main.play_hover_noise()



func _on_VolSlider_value_changed(ratio):
	ratio = clamp(ratio, 0, 1.0)
	AudioServer.set_bus_volume_db(0, log(ratio) * 20)


func _on_VolSlider_mouse_entered():
	if $VolumeTest.is_playing() == false:
		$VolumeTest.play()



func _on_VolSlider_mouse_exited():
	$VolumeTest.stop()
