extends Control

onready var tabs = $TabContainer

signal completed

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("deferred_ready")

func deferred_ready():
	#warning-ignore:return_value_discarded
	connect("completed", Game.main, "_on_UnderworldTransitionScreen_completed")

func next_page():
	var next_tab = tabs.get_current_tab()+1
	if next_tab < tabs.get_tab_count():
		tabs.set_current_tab(next_tab)


#warning-ignore:unused_argument
func _input(event):
	if visible and Input.is_action_just_pressed("ui_accept"):
		next_page()

func _on_NextPageButton_pressed():
	Game.main.play_click_noise()
	next_page()



func _on_ToUnderworldButton_pressed():
	Game.main.play_click_noise()
	emit_signal("completed")

func _on_ToOverworldButton_pressed():
	Game.main.play_click_noise()
	hide()
	tabs.set_current_tab(1)

	Game.main.return_to_overworld()


func _on_Button_hover():
	Game.main.play_hover_noise()

