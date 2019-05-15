extends Control

onready var tabs = $TabContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func next_page():
	var next_tab = tabs.get_current_tab()+1
	if next_tab == tabs.get_tab_count():
		hide()
	else:
		tabs.set_current_tab(next_tab)

#warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		next_page()

func _on_NextPageButton_pressed():
	next_page()
