extends Control


# Opens Level 1 when the Level 1 button is pressed
func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")


# Opens Level 2 when the Level 2 button is pressed
func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_2.tscn")


# Opens Level 3 when the Level 3 button is pressed
func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Level_3.tscn")


# Opens Level 4 when the Level 4 button is pressed
func _on_level_4_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_4.tscn")


# Opens Level 5 when the Level 5 button is pressed
func _on_level_5_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_5.tscn")
