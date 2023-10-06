extends Node2D
class_name Board

@onready var tile_map = $TileMap
@onready var timer = $Timer
@export var shape_delay: float = 1

var block_fact = BlockFactory.new()
var shape: PackedVector2Array
var block_atlas_coords: PackedVector2Array
var shape_pos: PackedVector2Array
var anchor_point_pos: Vector2
var middle_tile: int
var tile_num_width
var tile_map_scale
var blank_tile_pos
var BOARD_BOUNDS = PackedVector2Array([Vector2(8, 1), Vector2(17, 16)])
enum Block_Type {
	BLANK = 0,
	WALL = 1,
	FLOOR = 2,
	BLOCK = 3,
	CEILING = 4
}

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_num_width = tile_map.get_used_rect().size.x
	tile_map_scale = tile_map.scale
	middle_tile = tile_num_width / 2 - 1
	blank_tile_pos = Vector2(9, 3) # posicion de celda vacia en tilemap
	spawn_shape(0)

func spawn_shape(type):
	var tile_data: TileData
	
	shape_pos.clear() # limpia la posicion de la figura en el tablero
	shape = block_fact.get_shape(type)
	block_atlas_coords = block_fact.get_block_atlas_coords()
	
	# pinta en tilemap cada celda de la figura
	for n in shape.size():
		if type != 2:
			# guarda la posicion de la figura en el tablero para el movimiento
			shape_pos.append(shape[n] + Vector2(middle_tile, 1))
			
			# se guarda la posicion en el tablero del bloque con el punto de ancla
			if shape[n] == Vector2.ZERO:
				anchor_point_pos = shape_pos[n]
			
		elif anchor_point_pos:
			shape_pos.append(shape[n] + anchor_point_pos)
		
		tile_data = tile_map.get_cell_tile_data(0, shape_pos[n])
		if tile_data.get_custom_data_by_layer_id(0) == Block_Type.FLOOR:
			print("PENDEJO!!!")
			# TODO PENDEJO: game over
			get_tree().quit()
		
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
	var tile_data: TileData
	
	# itera cada bloque de la figura para verificar su siguiente posicion
	for block_pos in shape_pos.size():
		new_pos.append(shape_pos[block_pos] + direction)
		new_tile_data = tile_map.get_cell_tile_data(0, new_pos[block_pos])
		
		match new_tile_data.get_custom_data_by_layer_id(0):
			Block_Type.WALL:
				return true
			Block_Type.FLOOR:
				if direction == Vector2.DOWN:
					set_shape_as_floor()
					check_board_rows()
					spawn_shape(0)
					return false
				
				return true
	
	# una vez verificado que se puede mover a la siguiente posicion
	clear_shape()
	
	# y se vuelve a pinar la figura pero en su nueva posicion
	for n in new_pos.size():
		set_tile(new_pos[n], block_atlas_coords[n])
		shape_pos[n] = new_pos[n]
		
		# actualiza la posicion del bloque con punto de ancla
		if shape[n] == Vector2.ZERO:
			anchor_point_pos = shape_pos[n]
	
	return true

func set_tile(tile_pos, atlas_pos):
	tile_map.set_cell(0, tile_pos, 4, atlas_pos)

func clear_shape():
	for n in shape_pos.size():
		# se limpian las celdas actuales de la figura
		set_tile(shape_pos[n], blank_tile_pos)

func set_shape_as_floor():
	var pos: PackedVector2Array
	var tile_data: TileData
	var placed_block = block_fact.get_placed_block_atlas_coords()
	
	# recorre cada bloque de la figura
	for block_pos in shape_pos:
		# asigna a la posicion actual del bloque, otro bloque pero de tipo FLOOR
		tile_map.set_cell(0, block_pos, 4, placed_block)

func check_board_rows():
	var board = get_board()
	var completed_rows: Array
	var tile_data: TileData
	var empty_row = BOARD_BOUNDS[1].y + 1
	
	for row in board:
		var has_blank_block = false
		var is_empty = true
		
		for cell in row:
			if cell == Block_Type.BLANK:
				has_blank_block = true
			
			if cell == Block_Type.FLOOR:
				is_empty = false
		
		if is_empty:
			empty_row = board.find(row)
		
		if has_blank_block:
			continue
		
		completed_rows.append(board.find(row))
	
	var cell_atlas_coords
	var cell_tile_data: TileData
	var cell_pos
	
	for completed_row in completed_rows:
		for row in range(completed_row, empty_row, -1):
			for cell in board[row].size():
				cell_pos = Vector2(BOARD_BOUNDS[0].x + cell, BOARD_BOUNDS[0].y + row)
				
				if row == BOARD_BOUNDS[0].y:
					set_tile(cell_pos, blank_tile_pos)
					continue
				
				for n in completed_rows.size():
					cell_atlas_coords = tile_map.get_cell_atlas_coords(0, Vector2(cell_pos.x, cell_pos.y - 1))
					cell_tile_data = tile_map.get_cell_tile_data(0, cell_atlas_coords)
					
					set_tile(cell_pos, cell_atlas_coords)

func get_board():
	var board_custom_data: Array
	var tile_data: TileData
	
	for n in range(BOARD_BOUNDS[0].y, BOARD_BOUNDS[1].y + 1):
		var row: Array
		for m in range(BOARD_BOUNDS[0].x, BOARD_BOUNDS[1].x + 1):
			tile_data = tile_map.get_cell_tile_data(0, Vector2(m, n))
			row.append(tile_data.get_custom_data_by_layer_id(0))
		
		board_custom_data.append(row)
	return board_custom_data

func _unhandled_input(_event):
	if Input.is_action_pressed("left"):
		move(Vector2.LEFT)
	
	if Input.is_action_pressed("right"):
		move(Vector2.RIGHT)
	
	if Input.is_action_pressed("down"):
		move(Vector2.DOWN)
	
	if Input.is_action_just_pressed("drop"):
		while move(Vector2.DOWN):
			continue
		
	if Input.is_action_just_pressed("save"):
		clear_shape()
		spawn_shape(1)
	
	if Input.is_action_just_pressed("rotate_right"):
		clear_shape()
		spawn_shape(2)
