extends Control

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	visible = !visible
	get_tree().paused = visible


func _on_resume_button_pressed():
	visible = false
	get_tree().paused = false


func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")
