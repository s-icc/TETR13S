extends Node2D
class_name SaveWindow

@onready var globals = get_node("/root/Globals") as GameGlobals
@onready var leaderboard = get_node("/root/Leaderboard") as Leaderboards
@onready var line_edit = $Save/LineEdit as LineEdit
@onready var score_value = $"Save/Score value"
@onready var save_button = $Save/SaveButton

signal closed

func _ready():
	if score_value:
		score_value.text = str(globals.score)

func _on_button_pressed():
	var striped_text = line_edit.text.strip_edges()
	if striped_text:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
		# primero se ocupa guardar la informacion para que sea ordenada
		leaderboard.save_score(striped_text)
		leaderboard.visible = true
		closed.emit()

func _input(event):
	if Input.is_action_just_pressed("ui_text_submit"):
		_on_button_pressed()
