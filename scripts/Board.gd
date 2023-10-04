extends Node2D
class_name Board

@onready var tile_map = $TileMap
@onready var timer = $Timer
@export var shape_delay: float = 1

var block_fact = BlockFactory.new()
var shape: PackedVector2Array
var block_atlas_coord: Vector2
var shape_pos: PackedVector2Array
var tile_num_width
var tile_map_scale
var blank_tile_pos
var middle_tile: int

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_num_width = tile_map.get_used_rect().size.x
	tile_map_scale = tile_map.scale
	middle_tile = tile_num_width / 2 - 1
	blank_tile_pos = Vector2(9, 3)
	
	spawn_shape()

func spawn_shape():
	shape_pos.clear()
	shape = block_fact.get_shape()
	block_atlas_coord = block_fact.get_block_atlas_coord()
	
	for n in shape.size():
		shape_pos.append(shape[n] + Vector2(middle_tile, 1))
		tile_map.set_cell(0, shape_pos[n], 4, block_atlas_coord)
	
	timer.start(1)

func _physics_process(_delta):
	if !shape:
		return
	"""
	if shape.timer.time_left == 0 and !Input.is_action_pressed("down"):
		shape.move(Vector2.DOWN)
		shape.timer.start(shape_delay)
	"""
	
	if timer.time_left == 0:
		move(Vector2.DOWN)
		timer.start(1)

func move(direction):
	var new_pos: PackedVector2Array
	var new_tile_data: TileData
	
	for n in shape_pos.size():
		new_pos.append(shape_pos[n] + direction)
		
		new_tile_data = tile_map.get_cell_tile_data(0, new_pos[n])
		
		if !new_tile_data is TileData:
			continue
	
		match new_tile_data.get_custom_data_by_layer_id(0):
			1:
				return
			2:
				spawn_shape()
				# TODO: hacer todos los bloques de la figura del tipo floor
				return
	
	for n in shape_pos.size():
		set_tile(shape_pos[n], blank_tile_pos)
	
	for n in new_pos.size():
		new_tile_data = tile_map.get_cell_tile_data(0, new_pos[n])
				
		set_tile(new_pos[n], block_atlas_coord)
		
		shape_pos[n] = new_pos[n]
	

func set_tile(tile_pos, atlas_pos):
	tile_map.set_cell(0, tile_pos, 4, atlas_pos)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("left"):
		move(Vector2.LEFT)
	
	if Input.is_action_just_pressed("right"):
		move(Vector2.RIGHT)
	
	if Input.is_action_pressed("down"):
		move(Vector2.DOWN)
	
	if Input.is_action_just_pressed("rotate_left"):
		pass
	
	if Input.is_action_just_pressed("place"):
		pass
