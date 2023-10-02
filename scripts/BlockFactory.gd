extends Node
class_name BlockFactory

var blocks_scene = [
	preload("res://scenes/blocks/I.tscn"),
	preload("res://scenes/blocks/J.tscn"),
	preload("res://scenes/blocks/L.tscn"),
	preload("res://scenes/blocks/O.tscn"),
	preload("res://scenes/blocks/S.tscn"),
	preload("res://scenes/blocks/T.tscn"),
	preload("res://scenes/blocks/Z.tscn")
]

var block_scene = blocks_scene.pick_random()

func get_block():
	return block_scene.instantiate()
