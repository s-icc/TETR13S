extends Node2D

@onready var globals = get_node("/root/Globals") as GameGlobals
@onready var leaderboard = get_node("/root/Leaderboard") as Leaderboards
@onready var save = $Save
@onready var line_edit = $Save/LineEdit as LineEdit
@onready var score_value = $"Save/Score value"
@onready var save_button = $Save/SaveButton

func _ready():
	save.visible = true
	if score_value:
		score_value.text = str(globals.score)

func _on_button_pressed():
	var striped_text = line_edit.text.strip_edges(true, true)
	if striped_text:
		# primero se ocupa guardar la informacion para que sea ordenada
		leaderboard.save_score(striped_text)
		leaderboard.visible = true
		save.visible = false

func _input(event):
	if Input.is_action_just_pressed("ui_text_submit"):
		_on_button_pressed()
