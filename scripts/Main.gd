extends Node2D
class_name Main

@onready var animation_camera = $AnimationCamera

func shake_camera():
	animation_camera.play("cam_shake")
	await animation_camera.animation_finished
