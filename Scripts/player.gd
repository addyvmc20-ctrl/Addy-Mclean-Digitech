extends RigidBody3D 
 
var mouse_senstivity := 0.003 
var twist_input := 0.0 
var pitch_input := 0.0 
 
@export var jump_force := 12.0 
@export var move_force := 1200.0 
@export var air_move_force := 500.0 
@export var air_damp := 1.0 
 
var can_jump := false
var is_airborne := false
 
@onready var twist_pivot := $TwistPivot 
@onready var pitch_pivot := $TwistPivot/PitchPivot 
 
@onready var player_mesh := $NormalPlayer
@onready var jump_mesh := $JumpPlayer
@onready var jetpack_sound := $JetpackSound
@onready var pause_menu = get_tree().get_first_node_in_group("pause_menu") 
 
 
func _ready() -> void: 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	jump_mesh.visible = false
 
 
func _process(delta: float) -> void: 
	var input := Vector3.ZERO  
	input.x = Input.get_axis("move_left", "move_right") 
	input.z = Input.get_axis("move_forward", "move_back") 
 
	if can_jump: 
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
	jump_mesh.rotation.y = twist_pivot.rotation.y
 
	twist_input = 0.0 
	pitch_input = 0.0 
		 
	# --- JUMP --- 
	if Input.is_action_just_pressed("jump") and can_jump: 
		apply_central_impulse(Vector3.UP * jump_force)
		can_jump = false
		is_airborne = true
		
		player_mesh.visible = false
		jump_mesh.visible = true
		
		jetpack_sound.play()
 
 
func _unhandled_input(event: InputEvent) -> void: 
	# Camera Movement
	if event is InputEventMouseMotion: 
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED: 
			twist_input = -event.relative.x * mouse_senstivity
			pitch_input = -event.relative.y * mouse_senstivity 
 
 
 
func _integrate_forces(state):
	can_jump = false

	for i in range(state.get_contact_count()):
		var normal = state.get_contact_local_normal(i)

		if normal.dot(Vector3.UP) > 0.7:
			can_jump = true

			# Switch back to normal player after landing
			if is_airborne and linear_velocity.y <= 0.5:
				is_airborne = false
				player_mesh.visible = true
				jump_mesh.visible = false
				
				jetpack_sound.stop()
