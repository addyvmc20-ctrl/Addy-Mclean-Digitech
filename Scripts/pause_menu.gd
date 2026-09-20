
extends CanvasLayer

func _ready():
	# Keep the pause menu active while the game is paused.
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(event):
	# Pressing ESC opens or closes the pause menu.
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause():
	# Show or hide the pause menu and pause/unpause the game.
	visible = !visible
	get_tree().paused = visible
	
	if visible:
		# Show the mouse when the pause menu opens.
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		# Force the mouse to become visible again after the game has paused.
		# This helps prevent the exported game from keeping the cursor captured.
		await get_tree().process_frame
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		# Remove focus from any button that was previously selected.
		var focused = get_viewport().gui_get_focus_owner()
		if focused:
			focused.release_focus()
	else:
		# Capture the mouse again when returning to gameplay.
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_resume_pressed() -> void:
	# Resume the game and return the mouse to gameplay mode.
	get_tree().paused = false
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_levels_pressed() -> void:
	# Unpause the game before changing to the level menu.
	get_tree().paused = false
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Scenes/level_menu.tscn")


func _on_quit_pressed() -> void:
	# Quit the game when the Quit button is pressed.
	get_tree().quit()
