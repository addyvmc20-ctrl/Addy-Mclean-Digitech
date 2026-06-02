extends Node3D

@export var star_count := 20000
@export var radius := 2000.0

@onready var stars: MultiMeshInstance3D = $Stars
@onready var mm: MultiMesh = stars.multimesh
@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	randomize()
	generate_stars()

func generate_stars():
	for i in range(star_count):
		var dir = random_unit_vector()
		var pos = dir * radius

		var t = Transform3D()
		t.origin = pos

		var scale = randf_range(0.5, 1.5) * 0.02
		t.basis = Basis().scaled(Vector3.ONE * scale)

		mm.set_instance_transform(i, t)

		mm.set_instance_color(i, Color(1,1,1, randf_range(0.4, 1.0)))

func random_unit_vector():
	return Vector3(
		randf_range(-1,1),
		randf_range(-1,1),
		randf_range(-1,1)
	).normalized()

func _process(delta):
	if player:
		global_position = player.global_position
