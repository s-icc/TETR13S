extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	discord_sdk.state = "Idle"
	discord_sdk.refresh()
	# mueve el nodo para que pueda apreciarse el shader
	get_parent().move_child(self, 0)

func _on_button_2_pressed():
	get_tree().quit()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _unhandled_input(event):
	# cambiar cuando ya se agregue el boton
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://scenes/settings.tscn")
