extends CharacterBody2D
class_name Block

var timer = 0
var tile_size = 16
var tile_map_scale: Vector2
var dir_inputs = {
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT,
	"down": Vector2.DOWN
}
@onready var sprite = $Sprite2D

func init(_tile_map_scale):
	tile_map_scale = _tile_map_scale
	
	apply_scale(tile_map_scale)
	if sprite:
		position = Vector2(
			sprite.get_texture().get_width() / 2,
			sprite.get_texture().get_height() / 2
		) * tile_map_scale

func slide_down(delay):
	# basic timer
	if timer < delay:
		timer += get_physics_process_delta_time()
		return
	
	timer = 0
	# moves down only when timer equals delay
	return move("down")

func _unhandled_input(event):
	for dir in dir_inputs:
		if Input.is_action_just_pressed(dir):
			move(dir)

func move(dir):
	position += dir_inputs[dir] * tile_size * tile_map_scale
	

func rotate_left(): 
	rotation_degrees -= 90

func rotate_right():
	rotation_degrees += 90

func place():
	pass
