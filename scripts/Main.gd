extends Node2D
class_name Main

@onready var globals = get_node("/root/Globals") as GameGlobals
@onready var animation_camera = $AnimationCamera
@onready var score_value = $"HFlowContainer/Score Container/ScoreValue"
@onready var rows_value = $"HFlowContainer/Rows Container/RowsValue"
var save_window = preload("res://scenes/save_score.tscn").instantiate() as SaveWindow

func _ready():
	# se conectan las señales con las funciones para actualizar los valores
	globals.completed_rows_changed.connect(update_rows_value)
	globals.score_changed.connect(update_score_value)
	globals.game_over.connect(open_save_window)
	save_window.closed.connect(remove_save_window)
	globals.reset_game()
	
	discord_sdk.state = "Playing Solo"
	discord_sdk.refresh()
	# mueve el nodo para que pueda apreciarse el shader
	get_parent().move_child(self, 0)

func shake_camera():
	animation_camera.play("cam_shake")
	await animation_camera.animation_finished

func update_rows_value():
	rows_value.text = str(globals.completed_rows)

func update_score_value():
	score_value.text = str(globals.score)

func open_save_window():
	add_child(save_window)

func remove_save_window():
	remove_child(save_window)
	$ColorRect2.visible = false
	$Sprite2D.visible = false

func _on_music_1_finished():
	$Music1.play()

func _on_music_2_finished():
	$Music2.play()

func _on_music_3_finished():
	$Music3.play()

func _on_music_4_finished():
	$Music4.play()
