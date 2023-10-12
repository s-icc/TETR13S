extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	discord_sdk.state = "Idle"
	discord_sdk.refresh()

func _on_button_2_pressed():
	get_tree().quit()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
