extends Area3D

# Stores the file path of the next level that should be loaded
# This can be changed in the Inspector for each level
@export var next_level_path : String


func _on_body_entered(body):
	# Checks that it is the player entering the level portal
	if body.name == "Player":
		
		# Loads the next level using the file path set in the Inspector
		get_tree().change_scene_to_file(next_level_path)
