extends Area3D

@export var next_level_path : String

func _on_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene_to_file(next_level_path)
