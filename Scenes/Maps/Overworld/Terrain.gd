extends TileMap

export var map_width: int = 50
export var map_height: int = 50
export var map_name: String = "Overworld"

var ticks : int = 0


var tiles : Array = []
var tile_names : Array = []

var tile_groups : Dictionary = {
	"water" : [],
	"lava" : [],
	"asphalt" : [],
	"dirt" : [],
	"border" : [],
	"grass" : []
}


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	tiles = get_tileset().get_tiles_ids()
	for tile in tiles:
		tile_names.push_back(get_tileset().tile_get_name(tile))
	print(self.name, " tile_names == ", tile_names)
	assemble_tile_groups()

func assemble_tile_groups():
	for tile_id in get_tileset().get_tiles_ids():
		var tile_name = get_tileset().tile_get_name(tile_id).to_upper()

		for key in tile_groups.keys():
			if tile_name.find(key.to_upper()) != -1:
				tile_groups[key].push_back(tile_id)




func draw_map(offset : Vector2, size : Vector2):
	offset -= size/2


	var noise : OpenSimplexNoise = OpenSimplexNoise.new()

	if map_name == "Overworld":
		for row in range(size.y):
			for col in range(size.x):
				if get_cell(int(offset.x) + col, int(offset.y) + row) == -1:
					var noise_value : float = noise.get_noise_2d(offset.x + col, offset.y + row)
					var cell_type : int = 0
					var tile_group : String = ""
					if abs(noise_value) < 0.1:
						tile_group = "asphalt"
					elif abs(noise_value) < 0.2:
						tile_group = "grass"
					elif abs(noise_value) < 0.33:
						tile_group = "dirt"
					elif abs(noise_value) < 0.4:
						tile_group = "border"
					else:
						tile_group = "water"

					cell_type = get_random_tile(tile_group)
					set_cell(int(offset.x) + col, int(offset.y) + row, cell_type)

	elif map_name == "Underworld":
		for row in range(size.y):
			for col in range(size.x):
				if get_cell(int(offset.x) + col, int(offset.y) + row) == -1:
					var noise_value : float = noise.get_noise_2d(offset.x + col, offset.y + row)
					var cell_type : int = 0
					var tile_group : String = ""
					if abs(noise_value) < 0.33:
						tile_group = "dirt"
					elif abs(noise_value) < 0.4:
						tile_group = "border"
					else:
						tile_group = "lava"
					cell_type = get_random_tile(tile_group)
					set_cell(int(offset.x) + col, int(offset.y) + row, cell_type)



func get_random_tile(tile_group_name):
	var tile_group = tile_groups[tile_group_name]
	if tile_group.size() > 0:
		return tile_group[randi()%tile_group.size()]
	else:
		push_warning(self.name + "Can't find any " + tile_group_name + " tile.")


#warning-ignore:unused_argument
func _process(delta):
	ticks += 1

	if Game.camera_focus != null and is_instance_valid(Game.camera_focus):
		create_map_edges()

func create_map_edges():
	# create new tiles in front of the camera


	var pos = Game.camera_focus.get_global_position()
	#warning-ignore:unused_variable
	var rot = Game.camera_focus.get_global_rotation()



	var cell_coords = world_to_map(pos)
	var size = Vector2(map_width,map_height)
	draw_map(cell_coords, size)


func detect_tile(target_global_pos) -> int:
	var cell_location : Vector2 = world_to_map(target_global_pos)

	draw_map(cell_location, Vector2(2,2))
	var cell = get_cell(int(cell_location.x), int(cell_location.y))
	return cell



#func get_tile_name(target_global_pos):
#	var cell_location : Vector2 = world_to_map(target_global_pos)
#	draw_map(cell_location, Vector2(2,2))
#	var cell = get_cell(int(cell_location.x), int(cell_location.y))
#	var tile_name = get_tileset().tile_get_name(cell)
#	return tile_name
#	#return tile_name

func detect_grass(target_global_pos):
	var tile_type = detect_tile(target_global_pos)
	if tile_groups["grass"].has(tile_type):
		return true
	else:
		return false

func compare_tile(target_global_position, tile_group_name) -> bool:
	var tile_type = detect_tile(target_global_position)
	if tile_groups[tile_group_name].has(tile_type):
		return true
	else:
		return false

