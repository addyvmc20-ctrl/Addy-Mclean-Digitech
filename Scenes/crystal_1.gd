extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		print("Crystal collected!")

		var crystal_hud = get_tree().get_first_node_in_group("crystal_hud")

		if crystal_hud:
			crystal_hud.add_crystal()
		else:
			print("ERROR: Crystal HUD not found!")

		queue_free()
