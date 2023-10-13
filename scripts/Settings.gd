extends Node2D
class_name Settings

@onready var shader = get_node("/root/CrtShader")
@onready var globals = get_node("/root/Globals")
@onready var chkbox_crt = $"ColorRect/Chkbox CRT" as CheckBox
@onready var chkbox_shake = $"ColorRect/Chkbox Shake" as CheckBox

func _ready():
	# mueve el nodo para que pueda apreciarse el shader
	get_parent().move_child(self, 0)
	chkbox_crt.button_pressed = shader.get_node("CRT-Shader").visible
	chkbox_shake.button_pressed = globals.can_shake

func _on_check_box_pressed():
	shader.get_node("CRT-Shader").visible = chkbox_crt.button_pressed

func _on_chkbox_shake_pressed():
	globals.can_shake = chkbox_shake.button_pressed

func _unhandled_input(event):
	# agregar icono de regresar aparte de este atajo
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
