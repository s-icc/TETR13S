extends Node2D
class_name Board

@onready var globals = get_node("/root/Globals") as GameGlobals
@onready var textures = get_node("/root/GameTextures") as Textures
@onready var score_system = get_node("/root/Score") as ScoreSystem
@onready var tile_map = $TileMap
@onready var timer = $Timer

@export var row_delete_delay: float = 0.2
@export var block_delete_delay: float = 0.04

var main_scene: Main
var block_fact = ShapeFactory.new()
var shape: PackedVector2Array
var block_atlas_coords: PackedVector2Array
var shape_pos: PackedVector2Array
var anchor_point_pos: Vector2
var middle_tile: int
var placed_shape
var tile_num_width
var tile_map_scale
var shape_delay = 1
var rng = RandomNumberGenerator.new()
var cell_assign
var input_band = false
var blank_tile_pos
var BOARD_BOUNDS = PackedVector2Array([Vector2(8, 1), Vector2(17, 16)])
var BOARD_WIDTH = 10
var BOARD_HEIGHT = 16
enum Block_Type {
	BLANK = 0,
	LEFT_WALL = 1,
	FLOOR = 2,
	RIGHT_WALL = 3,
	CEILING = 4,
	BLOCK = 5
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var randy = rng.randi_range(0, 3)
	match randy:
		0:
			$TileMap.tile_set.get_source(4).texture = textures.original_tilemap
			
			cell_assign = 4
			$"../original".visible = true
			$"../Music4".play()
			
			for shape in $"Next shape".get_children():
				shape.texture = textures.original[shape.get_index()]
			
			for shape in $"Saved shape".get_children():
				shape.texture = textures.original[shape.get_index()]
		1:
			$TileMap.tile_set.get_source(4).texture = textures.retro_tilemap
			cell_assign = 5
			$"../ColorRect".visible = true
			$"../Music2".play()
			
			for shape in $"Next shape".get_children():
				shape.texture = textures.retro[shape.get_index()]
			
			for shape in $"Saved shape".get_children():
				shape.texture = textures.retro[shape.get_index()]
		2:
			$TileMap.tile_set.get_source(4).texture = textures.metal_tilemap
			cell_assign = 6
			$"../metal".visible = true
			$"../Music3".play()
			
			for shape in $"Next shape".get_children():
				shape.texture = textures.metal[shape.get_index()]
			
			for shape in $"Saved shape".get_children():
				shape.texture = textures.metal[shape.get_index()]
		3:
			$TileMap.tile_set.get_source(4).texture = textures.biriween_tilemap
			cell_assign = 7
			$"../biriween".visible = true
			$"../Music1".play()
			
			for shape in $"Next shape".get_children():
				shape.texture = textures.biriween[shape.get_index()]
			
			for shape in $"Saved shape".get_children():
				shape.texture = textures.biriween[shape.get_index()]

	main_scene = get_parent()
	tile_num_width = tile_map.get_used_rect().size.x
	tile_map_scale = tile_map.scale
	middle_tile = tile_num_width / 2 - 1
	blank_tile_pos = Vector2(9, 3) # posicion de celda vacia en tilemap
	spawn_shape(0)

func _physics_process(_delta):
	if !shape:
		return
	
	# al acabar el tiempo, mueve la figura una posicion abajo
	if timer.time_left == 0:
		move(Vector2.DOWN)
		timer.start(shape_delay)

func spawn_shape(type):
	for shape in $"Next shape".get_children():
		shape.hide()
	
	placed_shape = false
	shape_pos.clear() # limpia la posicion de la figura en el tablero
	shape = block_fact.get_shape(type)
	block_atlas_coords = block_fact.get_block_atlas_coords()
	
	# pinta en tilemap cada celda de la figura
	for n in shape.size():
		if type != 2:
			# guarda la posicion de la figura en el tablero para el movimiento
			shape_pos.append(shape[n] + Vector2(middle_tile, 1))
			continue
		
		if anchor_point_pos:
			shape_pos.append(shape[n] + anchor_point_pos)
	
	if type != 2:
		# inicia un temporizador con el delay establecido
		timer.start(shape_delay)
	
	# mover la posicion de la figura hasta que sea valida
	elif !is_valid_position(shape_pos, Vector2.ZERO):
		# mover hacia arriba
		while collides(shape_pos, Block_Type.FLOOR):
			shape_pos = translate_position(Vector2.UP)
		# intentar mover hacia abajo
		while collides(shape_pos, Block_Type.CEILING):
			shape_pos = translate_position(Vector2.DOWN)
		# intentar mover a la derecha
		while collides(shape_pos, Block_Type.LEFT_WALL):
			shape_pos = translate_position(Vector2.RIGHT)
		# intentar mover a la izquierda
		while collides(shape_pos, Block_Type.RIGHT_WALL):
			shape_pos = translate_position(Vector2.LEFT)
	
	var shown = block_fact.showShape(shape)
	$"Next shape".get_child(shown).show()
	
	if collides(shape_pos, Block_Type.FLOOR):
		set_physics_process(false)
		set_process_unhandled_input(false)
		$"../Lose".play()
		$"../ColorRect2".visible = true
		$"../Music1".stop()
		$"../Music2".stop()
		$"../Music3".stop()
		$"../Music4".stop()
		await get_tree().create_timer(2).timeout
		$"../Sprite2D".visible = true
		$"../Sprite2D/AnimationPlayer".play("Animation")
		discord_sdk.state = "Idle"
		discord_sdk.refresh()
		$"../Musica".play()
		input_band = true
	
	print_shape()

func print_shape():
	for block_pos in shape_pos.size():
		set_tile(shape_pos[block_pos], block_atlas_coords[block_pos])
		
		# actualiza la posicion del bloque con punto de ancla
		if shape[block_pos] == Vector2.ZERO:
			anchor_point_pos = shape_pos[block_pos]

func collides(shape_position, block_type):
	var tile_data: TileData
	
	for block_position in shape_position:
		tile_data = tile_map.get_cell_tile_data(0, block_position)
		
		# si el tile data es nulo, significa que la posicion esta fuera del tablero
		if !tile_data:
			continue
		
		if tile_data.get_custom_data_by_layer_id(0) == block_type:
			return true
	return false

func move(direction):
	var new_pos = translate_position(direction)
	var is_valid = is_valid_position(new_pos, direction)
	
	if is_valid and !placed_shape:
		# una vez verificado que se puede mover a la siguiente posicion
		clear_shape()
		# ocupamos actualizar la posicion de la figura para poder pintarla
		# en la nueva posicion
		shape_pos = new_pos
		# y se vuelve a pintar la figura pero en su nueva posicion
		print_shape()
	
	return is_valid

func translate_position(direction):
	var new_position: PackedVector2Array
	
	# itera cada bloque de la figura para verificar su siguiente posicion
	for block_pos in shape_pos:
		new_position.append(block_pos + direction)
	
	return new_position

func is_valid_position(shape_position, direction):
	var tile_data: TileData
	
	if collides(shape_position, Block_Type.FLOOR):
		if direction == Vector2.DOWN:
			placed_shape = true
			# posiciona la figura como piso
			set_shape_as_floor()
			check_board_rows()
		return false
	
	if collides(shape_position, Block_Type.LEFT_WALL) or collides(shape_position, Block_Type.RIGHT_WALL):
		return false
	
	if collides(shape_position, Block_Type.CEILING):
		return false
	
	return true

func set_tile(tile_pos, atlas_pos):
	tile_map.set_cell(0, tile_pos, cell_assign, atlas_pos)

func clear_shape():
	for block_pos in shape_pos:
		# se limpian las celdas actuales de la figura
		set_tile(block_pos, blank_tile_pos)

func set_shape_as_floor():
	var placed_block = block_fact.get_placed_block_atlas_coords()
	
	# recorre cada bloque de la figura
	for block_pos in shape_pos:
		# asigna a la posicion actual del bloque, otro bloque pero de tipo FLOOR
		set_tile(block_pos, placed_block)

func check_board_rows():
	var board = get_board()
	var completed_rows: Array
	var tile_data: TileData
	var empty_row = BOARD_HEIGHT + 1
	
	for row in board.size():
		var has_blank_block = false
		var is_empty = true
		
		for cell in board[row].size():
			match board[row][cell]:
				Block_Type.BLANK:
					has_blank_block = true
				Block_Type.FLOOR:
					is_empty = false
		
		# si en toda la fila hay bloques vacios
		if is_empty:
			empty_row = row
		
		# si en la fila no hay bloques vacios
		if has_blank_block:
			continue
		
		# guarda la posicion de la fila llena
		completed_rows.append(row)
	
	if !completed_rows.is_empty():
		set_physics_process(false)
		await clear_rows(completed_rows, empty_row)
		set_physics_process(true)
	
	spawn_shape(0)
	return

func clear_rows(completed_rows: Array, empty_row):
	var cell_pos
	
	$"../Line".set_pitch_scale(1.0)
	
	for cell in BOARD_WIDTH:
		for completed_row in completed_rows:
			# obtiene la posicion de la celda en el tile map
			cell_pos = Vector2(BOARD_BOUNDS[0].x + cell, BOARD_BOUNDS[0].y + completed_row)
			set_tile(cell_pos, blank_tile_pos)
		
		$"../Line".set_pitch_scale($"../Line".pitch_scale + cell * 0.05)
		$"../Line".play()
		await get_tree().create_timer(block_delete_delay).timeout
	
	$"../Line".set_pitch_scale(1.0)
	
	await get_tree().create_timer(row_delete_delay).timeout
	move_rows(completed_rows, empty_row)
	score_system.combo(completed_rows.size())
	if globals.can_shake:
		await main_scene.shake_camera()
	shape_delay -= 0.05

func move_rows(completed_rows: Array, empty_row):
	var cell_pos
	var cell_atlas_coords
	
	for completed_row in completed_rows:
		# en el rango desede la fila completada hasta la primer fila vacia
		for row in range(completed_row, empty_row - 1, -1):
			for cell in BOARD_WIDTH:
				# obtiene la posicion de la celda en el tile map
				cell_pos = Vector2(BOARD_BOUNDS[0].x + cell, BOARD_BOUNDS[0].y + row)
				
				# si la fila actual es el borde
				if row == BOARD_BOUNDS[0].y:
					# pinta toda la fila con bloques vacios
					set_tile(cell_pos, blank_tile_pos)
					continue
				
				# por cada fila completada
				# establece en la celda actual el bloque de la posicion de arriba
				cell_atlas_coords = tile_map.get_cell_atlas_coords(0, Vector2(cell_pos.x, cell_pos.y - 1))
				set_tile(cell_pos, cell_atlas_coords)
				$"../Line".play()

func get_board():
	var board_custom_data: Array
	var tile_data: TileData
	
	# en el rango de los limites del tablero dentro del tile map
	for n in range(BOARD_BOUNDS[0].y, BOARD_BOUNDS[1].y + 1):
		var row: Array
		for m in range(BOARD_BOUNDS[0].x, BOARD_BOUNDS[1].x + 1):
			# se agrega el custom data de cada celda
			tile_data = tile_map.get_cell_tile_data(0, Vector2(m, n))
			row.append(tile_data.get_custom_data_by_layer_id(0))
		
		board_custom_data.append(row)
	
	return board_custom_data

func _unhandled_input(_event):
	var tile_data: TileData
	if Input.is_action_pressed("left"):
		move(Vector2.LEFT)
		$"../Move".play()
	
	if Input.is_action_pressed("right"):
		move(Vector2.RIGHT)
		$"../Move".play()
	
	if Input.is_action_pressed("down"):
		move(Vector2.DOWN)
		$"../Move".play()
		score_system.add_score(1)
	
	if Input.is_action_just_pressed("drop"):
		while move(Vector2.DOWN):
			continue
		$"../Drop".play()
		score_system.add_score(5)
		
		
	if Input.is_action_just_pressed("save"):
		clear_shape()
		spawn_shape(1)
		var numb = block_fact.showSavedShape(shape)
		for shape in $"Saved shape".get_children():
			shape.hide()
		$"Saved shape".get_child(numb).show()
	
	if Input.is_action_just_pressed("rotate_right"):
		clear_shape()
		spawn_shape(2)

func _input(event):
	if !input_band:
		return
		
	if event is InputEventKey and event.is_pressed():
		globals.game_over.emit()
		input_band = false
