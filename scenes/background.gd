extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D/AnimationPlayer.play("Animation")

func _on_i_1_texture_changed():
	pass # Replace with function body.
