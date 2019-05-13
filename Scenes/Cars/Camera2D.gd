extends Camera2D

# Declare member variables here. Examples:
var DesiredZoom = Vector2(6, 6)
var Ticks :int = 0

var MinZoom = 0.3
var MaxZoom = 25.0

func _ready():
	Game.camera = self
	Game.camera_focus = get_parent()
	DesiredZoom = zoom


func _process(delta):
	Ticks += 1
	zoom = lerp(zoom, DesiredZoom, 0.2 * delta * 60)

func _draw():
	pass

func _input(event):
	if event is InputEventMouseButton and event.is_action("zoom_in"):
		DesiredZoom = zoom * 0.8
	if event is InputEventMouseButton and event.is_action("zoom_out"):
		DesiredZoom = zoom * 1.25

	DesiredZoom.x = clamp(DesiredZoom.x, MinZoom, MaxZoom)
	DesiredZoom.y = clamp(DesiredZoom.y, MinZoom, MaxZoom)
