extends Area3D

# Tracks whether this crystal has already been collected
var collected = false


func _ready():
	# Adds the crystal to a group so all crystals can be found together
	add_to_group("crystals")
	
	# Connects the body_entered signal to the collection function
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	# Checks that the player entered the crystal and that it hasn't
	# already been collected
	if body.name == "Player" and not collected:
		print("Crystal collected!")

		# Finds the Crystal HUD so the collected crystal can be
		# displayed on the player's screen
		var crystal_hud = get_tree().get_first_node_in_group("crystal_hud")

		if crystal_hud:
			# Tells the HUD to update the crystal counter/icon
			crystal_hud.add_crystal()
		else:
			print("ERROR: Crystal HUD not found!")

		# Marks the crystal as collected and hides it from the level
		collected = true
		hide()
		
		# Stops the hidden crystal from detecting collisions
		# until it is reset
		set_deferred("monitoring", false)


func reset_crystal():
	# Resets the crystal so it can be collected again after the player dies
	collected = false
	show()
	set_deferred("monitoring", true)
