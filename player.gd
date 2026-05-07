extends RigidBody3D

var mouse_senstivity := 0.003
var twist_input := 0.0
var pitch_input := 0.0

@export var jump_force := 12.0

var can_jump := false

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	var input := Vector3.ZERO 
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	apply_central_force(twist_pivot.basis * input * 1200.0 * delta)
	
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-30), deg_to_rad(30))

	twist_input = 0.0
	pitch_input = 0.0
		
	if Input.is_action_just_pressed("jump") and can_jump:
		apply_central_impulse(Vector3.UP * jump_force)
		can_jump = false
		
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event: InputEvent) -> void:
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
			break
