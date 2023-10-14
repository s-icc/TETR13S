extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D/AnimationPlayer.play("Animation")
	discord_sdk.state = "Idle"
	discord_sdk.refresh()
	# mueve el nodo para que pueda apreciarse el shader
	get_parent().move_child(self, 0)

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			get_tree().change_scene_to_file("res://scenes/menu.tscn")
