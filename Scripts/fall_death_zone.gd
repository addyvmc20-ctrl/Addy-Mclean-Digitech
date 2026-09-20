extends Area3D

# Sets where the player will be moved to after dying
@export var respawn_position := Vector3(0, 3, 0)

# Keeps track of how many times the player has died
var death_count := 0


func _on_body_entered(body):
	# Checks that the object entering the death area is the player
	if body.name == "Player":
		
		# Increase the death counter and play the death sound
		death_count += 1
		body.get_node("DeathSound").play()
		
		# Updates the death counter shown on the HUD
		$"../DeathCountHUD/Label".text = "Deaths: " + str(death_count)
		
		# Moves the player back to the starting position
		# and removes their movement so they don't keep falling/moving
		body.global_position = respawn_position
		body.linear_velocity = Vector3(0, 0, 0)
		body.angular_velocity = Vector3(0, 0, 0)
		
		# Finds the crystal HUD and resets the player's collected crystals
		# so they need to collect them again after dying
		var crystal_hud = get_tree().get_first_node_in_group("crystal_hud")
		if crystal_hud:
			crystal_hud.reset_crystals()
