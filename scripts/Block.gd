extends CharacterBody2D
class_name Block

var timer = 0
var down = Vector2(0, 16)
var left = Vector2(-16, 0)
var right = Vector2(16, 0)
var tile_map_scale: Vector2

func init(_tile_map_scale):
	tile_map_scale = _tile_map_scale
	down *= tile_map_scale
	left *= tile_map_scale
	right *= tile_map_scale
	
	apply_scale(tile_map_scale)
	var sprite: Sprite2D = $Sprite2D
	position = Vector2(sprite.get_texture().get_width()/2, sprite.get_texture().get_height()/2) * tile_map_scale

func slide_down(delta, delay):
	# basic timer
	if timer < delay:
		timer += delta
		return
	
	timer = 0
	# moves down only when timer equals delay
	move_and_collide(down)

func move_down():
	position += down

func move_left():
	position += left

func move_right():
	position += right

func rotate_left(): 
	rotation_degrees -= 90

func rotate_right():
	rotation_degrees += 90

func place():
	pass
