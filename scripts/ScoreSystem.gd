extends Node
class_name ScoreSystem

@onready var globals = get_node("/root/Globals") as GameGlobals
@export var score_per_row = 100
var combos = [0, 1.0, 1.2, 1.5, 2.0]

func combo(rows):
	globals.completed_rows += rows
	# al haberse cambiado los valores, se emiten las señales para actualizar los label
	globals.completed_rows_changed.emit() 
	add_score(combos[rows] * score_per_row)

func add_score(value):
	globals.score += value
	globals.score_changed.emit()

