extends Node
class_name BlockAbstractFactory

var blocks_scene = preload("res://scenes/blocks.tscn")
var blocks = blocks_scene.instantiate()

func get_block() -> Block:
	return blocks.get_node("I")
