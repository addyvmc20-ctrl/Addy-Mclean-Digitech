extends Node3D

# Controls the speed of rotation on each axis.
# These values can be adjusted in the Inspector.
@export var rotation_speed_y := 0.2
@export var rotation_speed_x := 0.03
@export var rotation_speed_z := 0.01


func _process(delta):
	# Rotates the object around the X, Y and Z axes.
	# Using delta keeps the rotation consistent across different frame rates.
	rotate_x(rotation_speed_x * delta)
	rotate_y(rotation_speed_y * delta)
	rotate_z(rotation_speed_z * delta)
