extends CharacterBody2D

@export var delay = 0.5
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(delta):
	move_down(delta)

func move_down(delta):
	# basic timer
	if timer < delay:
		timer += delta
		return
	
	timer = 0
	# moves down only when timer equals delay
	move_and_collide(Vector2(0, 16))
