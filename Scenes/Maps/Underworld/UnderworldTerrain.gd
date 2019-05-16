extends TileMap

export var map_width: int = 15
export var map_height: int = 15


var ticks : int = 0

enum tiles { ground, border, lava_cold, lava_hot, water_deep, water_shallow, grass, asphalt}
# ^^^^ needs to match the tilemap tile ids


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


func draw_map(offset : Vector2, size : Vector2):
	offset -= size/2


	var noise : OpenSimplexNoise = OpenSimplexNoise.new()

	for row in range(size.y):
		for col in range(size.x):
			if get_cell(int(offset.x) + col, int(offset.y) + row) == -1:
				var noise_value : float = noise.get_noise_2d(offset.x + col, offset.y + row)
				var cell_type : int = 0
				#print(self.name, "noise_value == ", noise_value)
				if abs(noise_value) < 0.33:
					cell_type = tiles.ground
				elif abs(noise_value) < 0.4:
					cell_type = tiles.border
				elif abs(noise_value) < 0.5:
					cell_type = tiles.lava_cold
				else:
					cell_type = tiles.lava_hot

				set_cell(int(offset.x) + col, int(offset.y) + row, cell_type)




# warning-ignore:unused_argument
func _process(delta):
	ticks += 1
	if Game.camera_focus != null and is_instance_valid(Game.camera_focus):
		create_map_edges()

func create_map_edges():
	# remove tiles behind the camera
	# create new tiles in front of the camera


	var pos = Game.camera_focus.get_global_position()
	var cell_coords = world_to_map(pos)
	var size = Vector2(map_width,map_height)
	draw_map(cell_coords, size)


func detect_tile(target_global_pos):
	var cell_location : Vector2 = world_to_map(target_global_pos)

	draw_map(cell_location, Vector2(5,5))
	var cell = get_cell(int(cell_location.x), int(cell_location.y))
	return cell
