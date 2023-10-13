extends Node
class_name GameShader

var crt_shader_scene = preload("res://scenes/CRTShader.tscn").instantiate()
var crt_shader_node: Node

func _ready():
	if crt_shader_scene:
		crt_shader_node = crt_shader_scene.get_node("CRT-Shader")
	
