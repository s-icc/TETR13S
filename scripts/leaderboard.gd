extends Node2D
class_name Leaderboards

@onready var globals = get_node("/root/Globals") as GameGlobals
@onready var table = $ColorRect/MarginContainer/RowsContainer/VBoxContainer
var row = preload("res://scenes/leaderboard_row.tscn")
var row_count = 0 
var save_path = "user://score.save"
var player_data: PackedStringArray

func _ready():
	visible = false

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	visible = false

func add_row(player_name: String):
	row_count += 1
	var row_instance = row.instantiate()
	row_instance.name = "Row" + str(row_count)
	table.add_child(row_instance)
	
	# cambiar la información de los label
	get_node("ColorRect/MarginContainer/RowsContainer/VBoxContainer/" + row_instance.name + "/Name").text = player_name.to_upper()
	get_node("ColorRect/MarginContainer/RowsContainer/VBoxContainer/" + row_instance.name + "/Score").text = str(globals.score)

func save_score(player_name):
	var player_data = PackedStringArray([player_name, globals.score])
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_csv_line(player_data, ":")
	load_score()

func load_score():
	if FileAccess.file_exists(save_path):
		print("file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		var player = file.get_csv_line(":")
	else:
		print("file not found")
		globals.highscore = 0
