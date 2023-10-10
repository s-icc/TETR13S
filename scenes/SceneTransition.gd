extends CanvasLayer

func change_scene(target: String) -> void:
	$AnimationPlayer.play("dissolve")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("dissolve")
