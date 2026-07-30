extends CanvasLayer

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	visible = !visible
	get_tree().paused = visible





func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_levels_pressed() -> void:
	get_tree().paused = false
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Scenes/level_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
