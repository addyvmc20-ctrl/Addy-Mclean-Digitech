extends Control


# Starts the game by loading Level 1
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")


# Opens the level selection menu
func _on_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_menu.tscn")


# Closes the game when the Quit button is pressed
func _on_quit_pressed() -> void:
	get_tree().quit()
