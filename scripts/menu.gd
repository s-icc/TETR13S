extends Node2D

var crtOFF
var crtON
var shakeOFF
var shakeON
var textureCRTOFF: Texture2D
var textureCRTON: Texture2D
var textureSHAKEOFF: Texture2D
var textureSHAKEON: Texture2D
@onready var shader = get_node("/root/CrtShader")
@onready var globals = get_node("/root/Globals")
# Called when the node enters the scene tree for the first time.
func _ready():
	discord_sdk.state = "Idle"
	discord_sdk.refresh()
	# mueve el nodo para que pueda apreciarse el shader
	get_parent().move_child(self, 0)
	textureCRTOFF = load("res://assets/Resources/crtOFF.png")
	textureCRTON = load("res://assets/Resources/crtON.png")
	textureSHAKEOFF = load("res://assets/Resources/shakeOFF.png")
	textureSHAKEON = load("res://assets/Resources/shakeON.png")
	$TextureButton.button_pressed = shader.get_node("CRT-Shader").visible
	$TextureButton2.button_pressed = globals.can_shake

func _on_button_2_pressed():
	get_tree().quit()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_button_3_pressed():
	$TextureRect2.visible = true
	$TextureRect3.visible = true
	$Button4.visible = true
	$TextureButton.visible = true
	$TextureButton2.visible = true
	
func _on_button_4_pressed():
	$TextureRect2.visible = false
	$TextureRect3.visible = false
	$Button4.visible = false
	$TextureButton.visible = false
	$TextureButton2.visible = false

func _on_video_stream_player_finished():
	$VideoStreamPlayer.play()

func _on_texture_button_toggled(button_pressed):
	if button_pressed == true:
		$TextureButton.set_texture_normal(textureCRTON)
		shader.get_node("CRT-Shader").visible = true
		get_parent().move_child(self, 0)
	else: 
		$TextureButton.set_texture_normal(textureCRTOFF)
		shader.get_node("CRT-Shader").visible = false

func _on_texture_button_2_toggled(button_pressed):
	if button_pressed == true:
		$TextureButton2.set_texture_normal(textureSHAKEON)
		globals.can_shake = true
	else: 
		$TextureButton2.set_texture_normal(textureSHAKEOFF)
		globals.can_shake = false
