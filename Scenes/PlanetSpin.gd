extends Node3D

@export var rotation_speed_y := 0.2
@export var rotation_speed_x := 0.03
@export var rotation_speed_z := 0.01

func _process(delta):
	rotate_x(rotation_speed_x * delta)
	rotate_y(rotation_speed_y * delta)
	rotate_z(rotation_speed_z * delta)
