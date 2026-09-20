extends AnimatableBody3D

# Variables that can be changed in the Inspector to control
# how far, how fast and in which direction the platform moves
@export var move_distance := 10.0
@export var move_speed := 2.0
@export var move_axis := Vector3.LEFT
@export var wait_time := 1.0

var start_position: Vector3
var direction := -1
var waiting := false


func _ready():
	# Saves the platform's original position so it knows
	# where to return to
	start_position = global_position
	
	# Normalises the movement direction so the platform
	# moves at a consistent speed
	move_axis = move_axis.normalized()


func _physics_process(delta):
	# Stops the platform from moving while it is waiting
	if waiting:
		return

	# Moves the platform along the selected axis
	# using speed and delta to keep the movement smooth
	global_position += move_axis * move_speed * direction * delta

	var moved_distance = (global_position - start_position).dot(move_axis)


	# Checks if the platform has reached its maximum distance
	if moved_distance < -move_distance:
		global_position = start_position + move_axis * -move_distance
		await _wait_and_flip()


	# Checks if the platform has returned to its starting point
	elif moved_distance > 0:
		global_position = start_position
		await _wait_and_flip()


func _wait_and_flip() -> void:
	# Temporarily stops the platform while it waits
	waiting = true
	
	# Creates a timer so the platform pauses at each end
	await get_tree().create_timer(wait_time).timeout
	
	# Reverses the direction of the platform
	direction *= -1
	waiting = false
