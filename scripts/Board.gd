extends Node2D
class_name Board

var block_fact = BlockFactory.new()
var block: Block
@export var block_delay = 0.5
@onready var tile_num_width = $TileMap.get_used_rect().size.x
@onready var tile_map_scale = $TileMap.scale

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_block()

func spawn_block():
	block = block_fact.get_block()
	var middle_tile: int = tile_num_width / 2
	block.init(tile_map_scale)
	block.translate(Vector2(middle_tile * 16 - 16, 16) * tile_map_scale)
	add_child(block, true)

func _physics_process(delta):
	if block:
		block.slide_down(delta, block_delay)
		

func _unhandled_input(_event):
	if Input.is_action_just_pressed("left"):
		block.move_left()
	
	if Input.is_action_just_pressed("right"):
		block.move_right()
	
	if Input.is_action_just_pressed("rotate_left"):
		block.rotate_left()
	
	if Input.is_action_just_pressed("rotate_right"):
		block.rotate_right()
	
	if Input.is_action_just_pressed("place"):
		block.place()
