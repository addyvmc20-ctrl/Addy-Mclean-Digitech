extends CanvasLayer

# Keeps track of how many crystals the player has collected
var crystals = 0

# Stores references to the three crystal icons in the HUD
@onready var crystal_icons = [
	$MarginContainer/HBoxContainer/crystal1,
	$MarginContainer/HBoxContainer/crystal2,
	$MarginContainer/HBoxContainer/crystal3
]

# Runs when the Crystal HUD is loaded
func _ready():
	# Adds this HUD to the "crystal_hud" group
	# This allows other scripts to find and control the HUD
	add_to_group("crystal_hud")


# Called when the player collects a crystal
func add_crystal():
	# Makes sure the player cannot collect more crystals
	# than there are icons in the HUD
	if crystals < crystal_icons.size():
		
		# Changes the next empty crystal icon to the full crystal texture
		crystal_icons[crystals].texture = load("res://Models/full_texture.png")
		
		# Increases the number of collected crystals by 1
		crystals += 1
		
		# Prints the current number of collected crystals in the Godot Output for testing
		print("Crystals collected:", crystals)


# Resets the crystal HUD when the player dies
func reset_crystals():
	# Sets the crystal count back to zero
	crystals = 0
	
	# Goes through every crystal icon in the HUD
	for icon in crystal_icons:
		
		# Changes each icon back to the empty crystal texture
		icon.texture = load("res://Models/empty_texture.png")
	
	# Prints a message in the Godot Output to confirm
	# that the crystals have been reset
	print("Crystals reset")
