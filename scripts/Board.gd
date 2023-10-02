extends Node2D
class_name Board

var blockAF = BlockAbstractFactory.new()
var block = blockAF.get_block()
@export var block_spawn = 2
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	if block:
		block.move_down()
	
	#if timer < block_spawn:
	#	timer += delta
	#	return
	
	#timer = 0
