extends Node2D
class_name Board

@onready var tile_map = $TileMap
@onready var timer = $Timer
@export var shape_delay: float = 1

var block_fact = BlockFactory.new()
var shape: PackedVector2Array
var block_atlas_coords: PackedVector2Array
var shape_pos: PackedVector2Array
var tile_num_width
var tile_map_scale
var blank_tile_pos
var middle_tile: int
enum Block_Type {
	BLANK = 0,
	WALL = 1,
	FLOOR = 2,
	BLOCK = 3
}

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_num_width = tile_map.get_used_rect().size.x
	tile_map_scale = tile_map.scale
	middle_tile = tile_num_width / 2 - 1
	blank_tile_pos = Vector2(9, 3) # posicion de celda vacia en tilemap
	
	spawn_shape()

func spawn_shape():
	shape_pos.clear() # limpia la posicion de la figura en el tablero
	shape = block_fact.get_shape()
	block_atlas_coords = block_fact.get_block_atlas_coords()
	
	# pinta en tilemap cada celda de la figura
	for n in shape.size():
		# guarda la posicion de la figura en el tablero para el movimiento
		shape_pos.append(shape[n] + Vector2(middle_tile, 1))
		tile_map.set_cell(0, shape_pos[n], 4, block_atlas_coords[n])
	
	# inicia un temporizador con 1 segundo
	timer.start(shape_delay)

func _physics_process(_delta):
	if !shape:
		return
	
	# al acabar el tiempo, mueve la figura una posicion abajo
	if timer.time_left == 0:
		move(Vector2.DOWN)
		timer.start(shape_delay)

func move(direction):
	var new_pos: PackedVector2Array
	var new_tile_data: TileData
	
	# itera cada bloque de la figura para verificar su siguiente posicion
	for block_pos in shape_pos.size():
		new_pos.append(shape_pos[block_pos] + direction)
		
		new_tile_data = tile_map.get_cell_tile_data(0, new_pos[block_pos])
		
		match new_tile_data.get_custom_data_by_layer_id(0):
			Block_Type.WALL:
				return true
			Block_Type.FLOOR:
				set_shape_as_floor()
				spawn_shape()
				return false
	
	# una vez verificado que se puede mover a la siguiente posicion
	for n in shape_pos.size():
		# se limpian las celdas actuales de la figura
		set_tile(shape_pos[n], blank_tile_pos)
	
	# y se vuelve a pinar la figura pero en su nueva posicion
	for n in new_pos.size():
		set_tile(new_pos[n], block_atlas_coords[n])
		shape_pos[n] = new_pos[n]
	
	return true

func set_tile(tile_pos, atlas_pos):
	tile_map.set_cell(0, tile_pos, 4, atlas_pos)

func set_shape_as_floor():
	var pos: PackedVector2Array
	var tile_data: TileData
	var placed_block = block_fact.get_placed_block_atlas_coords()
	
	# recorre cada bloque de la figura
	for block_pos in shape_pos:
		# asigna a la posicion actual del bloque, otro bloque pero de tipo FLOOR
		tile_map.set_cell(0, block_pos, 4, placed_block)

func _unhandled_input(_event):
	if Input.is_action_pressed("left"):
		move(Vector2.LEFT)
	
	if Input.is_action_pressed("right"):
		move(Vector2.RIGHT)
	
	if Input.is_action_pressed("down"):
		move(Vector2.DOWN)
	
	if Input.is_action_just_pressed("place"):
		while move(Vector2.DOWN):
			continue
