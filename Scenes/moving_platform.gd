extends AnimatableBody3D

@export var move_distance := 10.0
@export var move_speed := 2.0
@export var move_axis := Vector3.LEFT

var start_position: Vector3
var direction := -1

func _ready():
	start_position = global_position

func _physics_process(delta):
	global_position += move_axis * move_speed * direction * delta

	var moved_distance = (global_position - start_position).dot(move_axis)

	if moved_distance < -move_distance:
		direction = 1
	elif moved_distance > 0:
		direction = -1
