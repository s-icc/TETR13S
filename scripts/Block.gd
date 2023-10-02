extends CharacterBody2D
class_name Block

var timer = 0
var down = Vector2(0, 16)
var left = Vector2(-16, 0)
var right = Vector2(16, 0)

func init(tile_map_scale):
	down *= tile_map_scale
	left *= tile_map_scale
	right *= tile_map_scale
	
	apply_scale(tile_map_scale)
	position = tile_map_scale * 16

func move_down(delta, delay):
	# basic timer
	if timer < delay:
		timer += delta
		return
	
	timer = 0
	# moves down only when timer equals delay
	move_and_collide(down)

