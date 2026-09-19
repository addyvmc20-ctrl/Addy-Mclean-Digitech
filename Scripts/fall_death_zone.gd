extends Area3D

@export var respawn_position := Vector3(0, 3, 0)

var death_count := 0

func _on_body_entered(body):
	if body.name == "Player":
		# Add to death count
		death_count += 1
		body.get_node("DeathSound").play()
		
		# Update death counter GUI
		$"../DeathCountHUD/Label".text = "Deaths: " + str(death_count)
		
		# Reset player
		body.global_position = respawn_position
		body.linear_velocity = Vector3(0, 0, 0)
		body.angular_velocity = Vector3(0, 0, 0)
		
		# Reset crystal HUD
		var crystal_hud = get_tree().get_first_node_in_group("crystal_hud")
		if crystal_hud:
			crystal_hud.reset_crystals()
