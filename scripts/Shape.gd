extends Area2D
class_name Shape

@onready var timer = $Timer # Temporizador para hacer el movimiento cada x segundos
@onready var collision_polygon_2d = $CollisionPolygon2D
@onready var shape_cast_2d = $ShapeCast2D

var tile_size = 32  # Tamaño de la celda del tablero
var new_area = Area2D.new() # Nueva area en la que estara la nueva posicion
var board

func init(_board: Board):
	board = _board

func _ready():
	if collision_polygon_2d:
		new_area.add_child(collision_polygon_2d.duplicate())
		new_area.apply_scale(scale)
		add_sibling(new_area)

func move(direction):
	# Mueve la pieza en la dirección especificada
	var new_position = position + direction * tile_size
	if is_valid_position(new_position):
		position = new_position

func rotate_piece():
	# Rota la pieza 90 grados en sentido horario
	rotation_degrees += 90
	if not is_valid_position(position):
		rotation_degrees -= 90

func is_valid_position(new_position):
	
	new_area.position = new_position
	new_area.rotation_degrees = rotation_degrees
	
	# Comprueba si la nueva posición de la pieza es válida en el tablero
	for area in new_area.get_overlapping_areas():
		if area != self:
			return false
	return true
	
