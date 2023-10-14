extends Node
class_name GameGlobals

var can_shake = false
var completed_rows = 0
var score = 0
var highscore = 0
var shape_delay = 1

signal completed_rows_changed
signal score_changed
signal game_over

func reset_game():
	completed_rows = 0
	score = 0
	shape_delay = 1
	completed_rows_changed.emit()
	score_changed.emit()
