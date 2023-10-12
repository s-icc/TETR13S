extends Node
class_name ScoreSystem

var score = 0
@export var score_per_row = 100
var combos = [0, 1.0, 1.2, 1.5, 2.0]

func combo(rows):
	score += combos[rows] * score_per_row


