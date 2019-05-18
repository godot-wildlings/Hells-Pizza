extends Control

var ticks : int = 0

var time_remaining : float = 60.0

onready var cash_on_hand = $PanelLeft/MarginContainer/VBox/CashOnHand
onready var instructions_label = $PanelTop/MarginContainer/InstructionLabel
onready var pizza_ammo = $PanelLeft/MarginContainer/VBox/PizzaAmmo
onready var stop_watch = $PanelLeft/MarginContainer/VBox/StopWatch


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#warning-ignore:unused_argument
func _process(delta):

	ticks += 1
	update()

	if ticks % 20 == 0:
		var cash_string = "$" + "%6.2f" % Game.player.cash
		cash_on_hand.set_text(cash_string)

	if Game.player.current_destination != Game.map.pizza_factory:
		time_remaining -= delta


	pizza_ammo.set_value(Game.player.pizza_ammo)
	if Game.player.pizza_ammo == 0:
		instructions_label.set_text("Return to the pizzeria to pick up more pizzas.\nFollow the green arrow.")
	else:
		instructions_label.set_text("Follow the green arrow to your delivery destination.\nClick the mouse to deliver a pizza.")

func _draw():
	var clock_rect = stop_watch
	var clock_size : Vector2 = clock_rect.get_size()
	var clock_pos = clock_rect.get_position() + clock_size/2
	var radius = clock_size.x / 2
	draw_circle(clock_pos , radius, Color(1, 1, 1, 1))
	var second_pos = clock_pos + Vector2.UP.rotated(time_remaining / 60.0 * 2 * PI) * radius
	draw_line(clock_pos, second_pos, Color.black, 1.0, false  )

func reset_clock():
	time_remaining = 60.0
	update()

