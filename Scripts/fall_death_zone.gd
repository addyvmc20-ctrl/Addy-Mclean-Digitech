extends Area3D

@export var respawn_position := Vector3(0, 3, 0)

func _on_body_entered(body):
	if body.name == "Player":
		body.global_position = respawn_position
		body.linear_velocity = Vector3(0, 0, 0)
		body.angular_velocity = Vector3(0, 0, 0)

		# Reset crystal HUD
		var crystal_hud = get_tree().get_first_node_in_group("crystal_hud")
		if crystal_hud:
			crystal_hud.reset_crystals()

		# Reset all crystals in the level
		for crystal in get_tree().get_nodes_in_group("crystals"):
			crystal.reset_crystal()
