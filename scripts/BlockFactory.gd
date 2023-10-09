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
	PackedVector2Array([Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(2, 0)]), # I
	PackedVector2Array([Vector2(0, 0), Vector2(-1, 0), Vector2(1, 0), Vector2(1, 1)]), # J
	PackedVector2Array([Vector2(0, 0), Vector2(-2, 1), Vector2(-1, 1), Vector2(0, 1)]), # L
	PackedVector2Array([Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)]), # O
	PackedVector2Array([Vector2(0, 0), Vector2(1, 0), Vector2(-1, 1), Vector2(0, 1)]), # S
	PackedVector2Array([Vector2(0, 0), Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1)]), # T
	PackedVector2Array([Vector2(0, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(1, 1)]) # Z
]

var shapes2 = [
	PackedVector2Array([Vector2(0, 1), Vector2(0, 2), Vector2(0, 3), Vector2(0, 4)]), # I
	PackedVector2Array([Vector2(0, 0), Vector2(0, -1), Vector2(0, 1), Vector2(-1, 1)]), # J
	PackedVector2Array([Vector2(1, 2), Vector2(0, 0), Vector2(0, 1), Vector2(0, 2)]), # L
	PackedVector2Array([Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)]), # O
	PackedVector2Array([Vector2(0, 0), Vector2(0, 1), Vector2(1, 1), Vector2(1, 2)]), # S
	PackedVector2Array([Vector2(0, 0), Vector2(0, 1), Vector2(0, 2), Vector2(1, 1)]), # T
	PackedVector2Array([Vector2(0, 0), Vector2(-1, 0), Vector2(0, -1), Vector2(-1, 1)]) # Z
]

var shapes3 = [
	PackedVector2Array([Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(2, 0)]), # I
	PackedVector2Array([Vector2(0, 0), Vector2(-1, 0), Vector2(-1, -1), Vector2(1, 0)]), # J
	PackedVector2Array([Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(0, 1)]), # L
	PackedVector2Array([Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)]), # O
	PackedVector2Array([Vector2(0, 0), Vector2(1, 0), Vector2(-1, 1), Vector2(0, 1)]), # S
	PackedVector2Array([Vector2(0, 0), Vector2(-1, 0), Vector2(1, 0), Vector2(0, 1)]), # T
	PackedVector2Array([Vector2(0, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(1, 1)]) # Z
]

var shapes4 = [
	PackedVector2Array([Vector2(0, 1), Vector2(0, 2), Vector2(0, 3), Vector2(0, 4)]), # I
	PackedVector2Array([Vector2(0, 0), Vector2(0, -1), Vector2(1, -1), Vector2(0, 1)]), # J
	PackedVector2Array([Vector2(0, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, 2)]), # L
	PackedVector2Array([Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(1, 1)]), # O
	PackedVector2Array([Vector2(0, 0), Vector2(0, 1), Vector2(1, 1), Vector2(1, 2)]), # S
	PackedVector2Array([Vector2(0, 0), Vector2(0, 1), Vector2(0, 2), Vector2(-1, 1)]), # T
	PackedVector2Array([Vector2(0, 0), Vector2(-1, 0), Vector2(0, -1), Vector2(-1, 1)]) # Z
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
var shape2
var shapeInv
var rotate = 0
var sShape = 0
var xShape = 0
var rotShape

func get_shape(type):
	match type:
		0:
			rotate = 0
			if !shape2:
				shape = shapes.pick_random()
				shape2 = shapes.pick_random()
				rotShape = shape
			else:
				shape = shape2
				shape2 = shapes.pick_random()
				rotShape = shape
		1:
			if !shapeInv:
				shapeInv = shape
				shape = shape2
				shape2 = shapes.pick_random()
				rotShape = shape
				rotate = 0
			else:
				var temp = shape
				shape = shapeInv
				shapeInv = temp
				rotShape = shape
				rotate = 0
		2:
			if rotShape:
				rotate += 1
				match rotate:
					1: rotShape = shapes2[shapes.find(rotShape)]
					2: rotShape = shapes3[shapes2.find(rotShape)]
					3: rotShape = shapes4[shapes3.find(rotShape)]
					4: 
						rotate = 0
						rotShape = shapes[shapes4.find(rotShape)]
			return rotShape
	return shape

func get_block_atlas_coords():
	match rotate:
		0: return blocks_atlas_coords[shapes.find(rotShape)]
		1: return blocks_atlas_coords[shapes2.find(rotShape)]
		2: return blocks_atlas_coords[shapes3.find(rotShape)]
		3: return blocks_atlas_coords[shapes4.find(rotShape)]

func get_placed_block_atlas_coords():
	match rotate: 
		0: return placed_blocks_atlas_coords[shapes.find(rotShape)]
		1: return placed_blocks_atlas_coords[shapes2.find(rotShape)]
		2: return placed_blocks_atlas_coords[shapes3.find(rotShape)]
		3: return placed_blocks_atlas_coords[shapes4.find(rotShape)]
	

func showShape(shape):
	if shape2 == shapes[0]:
		sShape = 1
	elif shape2 == shapes[1]:
		sShape = 2
	elif shape2 == shapes[2]:
		sShape = 3
	elif shape2 == shapes[3]:
		sShape = 4
	elif shape2 == shapes[4]:
		sShape = 5
	elif shape2 == shapes[5]:
		sShape = 6
	elif shape2 == shapes[6]:
		sShape = 7
	return sShape
	
func showSavedShape(shapeX):
	if shapeInv == shapes[0]:
		xShape = 1
	elif shapeInv == shapes[1]:
		xShape = 2
	elif shapeInv == shapes[2]:
		xShape = 3
	elif shapeInv == shapes[3]:
		xShape = 4
	elif shapeInv == shapes[4]:
		xShape = 5
	elif shapeInv == shapes[5]:
		xShape = 6
	elif shapeInv == shapes[6]:
		xShape = 7
	return xShape
