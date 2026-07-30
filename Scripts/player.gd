extends RigidBody3D

var mouse_senstivity := 0.003
var twist_input := 0.0
var pitch_input := 0.0

@export var jump_force := 12.0
@export var move_force := 1200.0
@export var air_move_force := 500.0
@export var air_damp := 1.0

var can_jump := false
var touching_ice := false

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

@onready var player_mesh := $Digi_astronaut_player7
@onready var pause_menu = get_tree().get_first_node_in_group("pause_menu")


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta: float) -> void:
	var input := Vector3.ZERO 
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")

	if touching_ice:
		linear_damp = 0.1
	elif can_jump:
		linear_damp = 3.0
	else:
		linear_damp = air_damp

	var current_move_force := move_force

	if not can_jump:
		current_move_force = air_move_force

	apply_central_force(twist_pivot.basis * input * current_move_force * delta)

	# --- CAMERA ROTATION ---
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)

	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		deg_to_rad(-90),
		deg_to_rad(30)
	)

	player_mesh.rotation.y = twist_pivot.rotation.y

	twist_input = 0.0
	pitch_input = 0.0
		
	if Input.is_action_just_pressed("jump") and can_jump:
		apply_central_impulse(Vector3.UP * jump_force)
		can_jump = false
		
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _unhandled_input(event: InputEvent) -> void:
	#Camara Movement
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_senstivity
			pitch_input = -event.relative.y * mouse_senstivity



func _integrate_forces(state):
	can_jump = false
	touching_ice = false

	for i in range(state.get_contact_count()):
		var normal = state.get_contact_local_normal(i)
		var body = state.get_contact_collider_object(i)

		if normal.dot(Vector3.UP) > 0.7:
			can_jump = true

			if body != null and body.is_in_group("ice"):
				touching_ice = true
	
	
	
