extends TileMap

export var map_width: int = 15
export var map_height: int = 15


var ticks : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#create_paths(Vector2.ZERO, Vector2(map_width, map_height))


func draw_map(offset : Vector2, size : Vector2):
	offset -= size/2
	ticks += 1

	var noise : OpenSimplexNoise = OpenSimplexNoise.new()

	for row in range(size.y):
		for col in range(size.x):
			if get_cell(int(offset.x) + col, int(offset.y) + row) == -1:
				var noise_value : float = noise.get_noise_2d(offset.x + col, offset.y + row)
				var cell_type : int = 0
				#print(self.name, "noise_value == ", noise_value)
				if abs(noise_value) < 0.15:
					cell_type = 1
				elif abs(noise_value) < 0.33:
					cell_type = 2
				elif abs(noise_value) < 0.66:
					cell_type = 3
				else:
					cell_type = 0

				set_cell(int(offset.x) + col, int(offset.y) + row, cell_type)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	create_map_edges()

func create_map_edges():
	# remove tiles behind the camera
	# create new tiles in front of the camera

	var pos = Game.camera_focus.get_global_position()
	var cell_coords = world_to_map(pos)
	var size = Vector2(map_width,map_height)
	draw_map(cell_coords, size)


