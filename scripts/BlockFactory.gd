extends Node
class_name BlockFactory

var placed_blocks_atlas_coords = PackedVector2Array([
	Vector2(0, 0), # I
	Vector2(2, 0), # J
	Vector2(5, 0), # L
	Vector2(4, 0), # O
	Vector2(1, 0), # S
	Vector2(3, 0), # T
	Vector2(6, 0) # Z
])

var shapes = [
	PackedVector2Array([Vector2(0, 0), Vector2(0, 1), Vector2(0, 2), Vector2(0, 3)]), # I
	PackedVector2Array([Vector2(0, 0), Vector2(0, 1), Vector2(1, 1), Vector2(2, 1)]), # J
	PackedVector2Array([Vector2(0, 0), Vector2(-2, 1), Vector2(-1, 1), Vector2(0, 1)]), # L
	PackedVector2Array([Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)]), # O
	PackedVector2Array([Vector2(0, 0), Vector2(1, 0), Vector2(-1, 1), Vector2(0, 1)]), # S
	PackedVector2Array([Vector2(0, 0), Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1)]), # T
	PackedVector2Array([Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(2, 1)]) # Z
]

var blocks_atlas_coords = [
	PackedVector2Array([Vector2(0, 13), Vector2(0, 14), Vector2(0, 15), Vector2(0, 16)]), # I
	PackedVector2Array([Vector2(0, 9), Vector2(0, 10), Vector2(1, 10), Vector2(2, 10)]), # J
	PackedVector2Array([Vector2(2, 3), Vector2(0, 4), Vector2(1, 4), Vector2(2, 4)]), # L
	PackedVector2Array([Vector2(0, 5), Vector2(1, 5), Vector2(0, 6), Vector2(1, 6)]), # O
	PackedVector2Array([Vector2(1, 11), Vector2(2, 11), Vector2(0, 12), Vector2(1, 12)]), # S
	PackedVector2Array([Vector2(1, 7), Vector2(0, 8), Vector2(1, 8), Vector2(2, 8)]), # T
	PackedVector2Array([Vector2(0, 1), Vector2(1, 1), Vector2(1, 2), Vector2(2, 2)]) # Z
]

var shape

func get_shape():
	shape = shapes.pick_random()
	return shape

func get_block_atlas_coords():
	return blocks_atlas_coords[shapes.find(shape)]

func get_placed_block_atlas_coords():
	return placed_blocks_atlas_coords[shapes.find(shape)]
