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

func get_block():
	return blocks_scene.pick_random().instantiate()
