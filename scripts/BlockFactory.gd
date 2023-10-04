extends Node
class_name BlockFactory

var block_atlas_coords = PackedVector2Array([
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

var shape

func get_shape():
	#return shapes_scene[0].instantiate()
	shape = shapes.pick_random()
	return shape

func get_block_atlas_coord():
	return block_atlas_coords[shapes.find(shape)]
