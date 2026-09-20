extends RigidBody3D

# Controls how sensitive the mouse is when moving the camera
var mouse_senstivity := 0.003

# Stores mouse movement used to rotate the camera
var twist_input := 0.0
var pitch_input := 0.0


# These values control the player's movement and jumping.
# They can be adjusted in the Inspector.
@export var jump_force := 12.0
@export var move_force := 1200.0
@export var air_move_force := 500.0
@export var air_damp := 1.0


# Tracks whether the player is touching the ground
# and whether they are currently in the air
var can_jump := false
var is_airborne := false


# References the camera pivot nodes used to control
# horizontal and vertical camera movement
@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot


# References the two player models and the jetpack sound
@onready var player_mesh := $NormalPlayer
@onready var jump_mesh := $JumpPlayer
@onready var jetpack_sound := $JetpackSound

@onready var pause_menu = get_tree().get_first_node_in_group("pause_menu")


func _ready() -> void:
	# Captures the mouse so it can control the camera during gameplay
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Starts with the normal astronaut visible
	# and the jumping astronaut hidden
	jump_mesh.visible = false


func _process(delta: float) -> void:
	# Gets the player's movement input from the keyboard
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")


	# Applies more damping when the player is on the ground
	# and less damping while airborne
	if can_jump:
		linear_damp = 3.0
	else:
		linear_damp = air_damp


	# Uses a different movement force while the player is airborne
	var current_move_force := move_force

	if not can_jump:
		current_move_force = air_move_force


	# Moves the player relative to the direction the camera is facing
	apply_central_force(twist_pivot.basis * input * current_move_force * delta)


	# --- CAMERA ROTATION ---

	# Rotates the camera horizontally and vertically using mouse input
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)


	# Limits how far the player can look up and down
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		deg_to_rad(-90),
		deg_to_rad(30)
	)


	# Keeps the astronaut models facing the same direction
	# as the camera's horizontal rotation
	player_mesh.rotation.y = twist_pivot.rotation.y
	jump_mesh.rotation.y = twist_pivot.rotation.y


	# Resets the mouse input after it has been applied
	twist_input = 0.0
	pitch_input = 0.0


	# --- JUMP ---

	# Checks if the jump button was pressed while the player is grounded
	if Input.is_action_just_pressed("jump") and can_jump:
		
		# Applies an upward force to launch the player
		apply_central_impulse(Vector3.UP * jump_force)
		
		can_jump = false
		is_airborne = true


		# Changes to the jumping astronaut animation/model
		player_mesh.visible = false
		jump_mesh.visible = true
		
		# Plays the jetpack sound when the player jumps
		jetpack_sound.play()


func _unhandled_input(event: InputEvent) -> void:
	# Detects mouse movement and uses it to control the camera
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_senstivity
			pitch_input = -event.relative.y * mouse_senstivity


func _integrate_forces(state):
	# Assumes the player is airborne until a suitable
	# ground contact is detected
	can_jump = false


	# Checks all objects currently touching the player
	for i in range(state.get_contact_count()):
		var normal = state.get_contact_local_normal(i)


		# Uses the contact surface direction to determine
		# whether the player is standing on the ground
		if normal.dot(Vector3.UP) > 0.7:
			can_jump = true


			# When the player lands, switch back to the normal
			# astronaut model and stop the jetpack sound
			if is_airborne and linear_velocity.y <= 0.5:
				is_airborne = false
				player_mesh.visible = true
				jump_mesh.visible = false
				
				jetpack_sound.stop()
