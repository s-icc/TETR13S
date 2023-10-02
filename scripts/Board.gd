extends Node2D
class_name Board

var block_fact = BlockFactory.new()
var block = block_fact.get_block() as Block
@export var block_delay = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	block.translate(Vector2(112, 16))
	add_child(block, true)

func _physics_process(delta):
	block.move_down(delta, block_delay)
