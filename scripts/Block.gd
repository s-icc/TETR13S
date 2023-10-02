extends CharacterBody2D
class_name Block

var delay = 0.5
var timer = 0

func move_down():
	# basic timer
	if timer < delay:
		timer += get_physics_process_delta_time()
		return
	
	timer = 0
	# moves down only when timer equals delay
	move_and_collide(Vector2(0, 16))
