extends Node2D
class_name Leaderboards

@onready var globals = get_node("/root/Globals") as GameGlobals
@onready var table = $TextureRect2/MarginContainer/RowsContainer/VBoxContainer
var row = preload("res://scenes/leaderboard_row.tscn")
var row_count = 0 
var save_path = "user://score.save"

func _ready():
	visible = false
	load_score()

func _on_back_pressed():
	visible = false

func add_row(player_name: String, score):
	row_count += 1
	
	var row_instance = row.instantiate()
	row_instance.name = "Row" + str(row_count)
	table.add_child(row_instance)
	
	# cambiar la información de los label
	table.get_node(row_instance.name + "/Name").text = player_name
	table.get_node(row_instance.name + "/Score").text = str(score)

func save_score(player_name: String):
	var file: FileAccess
	
	if !FileAccess.file_exists(save_path):
		file = FileAccess.open(save_path, FileAccess.WRITE)
		file.close()
	
	file = FileAccess.open(save_path, FileAccess.READ_WRITE)
	file.seek_end(-1)
	file.store_line(player_name + ":" + str(globals.score) + "\n")
	file.close()
	update_table()

func load_score():
	if FileAccess.file_exists(save_path):
		update_table()
	else:
		FileAccess.open(save_path, FileAccess.WRITE)
		globals.highscore = 0

func customComparison(a, b):
	if int(a[1]) != int(b[1]):
		if int(a[1]) < int(b[1]):
			return true
	return false

func update_table():
	var file = FileAccess.open(save_path, FileAccess.READ)
	var player = file.get_csv_line(":")
	var players_arr: Array
	
	# limpia las filas de la tabla
	for child in table.get_children():
		table.remove_child(child)
	
	# mientras haya lineas con datos de jugadores
	while player.size() == 2:
		players_arr.append(player)
		player = file.get_csv_line(":")
	
	# ordena las filas
	players_arr.sort_custom(customComparison)
	players_arr.reverse()
	
	globals.highscore = int(players_arr[0][1])
	for n in players_arr.size():
		add_row(players_arr[n][0], players_arr[n][1])
	
	file.close()
