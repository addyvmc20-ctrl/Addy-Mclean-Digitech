extends Area3D

var collected = false

func _ready():
	add_to_group("crystals")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player" and not collected:
		print("Crystal collected!")

		var crystal_hud = get_tree().get_first_node_in_group("crystal_hud")

		if crystal_hud:
			crystal_hud.add_crystal()
		else:
			print("ERROR: Crystal HUD not found!")

		collected = true
		hide()
		set_deferred("monitoring", false)

func reset_crystal():
	collected = false
	show()
	set_deferred("monitoring", true)
