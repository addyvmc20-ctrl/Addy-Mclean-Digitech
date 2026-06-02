extends Area3D

@export var respawn_position := Vector3(0, 3, 0)

func _on_body_entered(body):
	if body.name == "Player":
		body.global_position = respawn_position
		body.linear_velocity = Vector3(0, 0, 0)
		body.angular_velocity = Vector3(0, 0, 0)
