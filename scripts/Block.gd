extends CharacterBody2D
class_name Block

var timer = 0
var down = Vector2(0, 16)
var left = Vector2(-16, 0)
var right = Vector2(16, 0)

func move_down(delta, delay):
	# basic timer
	if timer < delay:
		timer += delta
		return
	
	timer = 0
	# moves down only when timer equals delay
	move_and_collide(down)

