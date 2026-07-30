extends CanvasLayer

var crystals = 0

@onready var crystal_icons = [
	$MarginContainer/HBoxContainer/crystal1,
	$MarginContainer/HBoxContainer/crystal2,
	$MarginContainer/HBoxContainer/crystal3
]

func _ready():
	add_to_group("crystal_hud")

func add_crystal():
	if crystals < crystal_icons.size():
		crystal_icons[crystals].texture = load("res://Models/full_texture.png")
		crystals += 1
		print("Crystals collected:", crystals)
