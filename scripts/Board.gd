extends Node2D
class_name Board

var block_fact = BlockFactory.new()
var block = block_fact.get_block() as Block
@export var block_delay = 0.5
@onready var tile_num_width = $TileMap.get_used_rect().size.x
@onready var tile_map_scale = $TileMap.scale

# Called when the node enters the scene tree for the first time.
func _ready():
	var middle_tile: int = tile_num_width / 2
	block.init(tile_map_scale)
	block.translate(Vector2(middle_tile * 16 - 16, 16) * tile_map_scale)
	add_child(block, true)

func _physics_process(delta):
	block.move_down(delta, block_delay)
