extends Node2D
class_name Main

@onready var animation_camera = $AnimationCamera

func _ready():
	discord_sdk.state = "Playing Solo"
	discord_sdk.refresh()

func shake_camera():
	animation_camera.play("cam_shake")
	await animation_camera.animation_finished
