extends Node2D
class_name Main

@onready var animation_camera = $AnimationCamera

func _ready():
	discord_sdk.state = "Playing Solo"
	discord_sdk.refresh()
	# mueve el nodo para que pueda apreciarse el shader
	get_parent().move_child(self, 0)

func shake_camera():
	animation_camera.play("cam_shake")
	await animation_camera.animation_finished
