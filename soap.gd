extends CharacterBody3D

@export var speed = 10
@export var fall_acceleration = 75
@export var jump_velocity = 6
@export var mouse_sensitivity = 0.005

var target_velocity = Vector3.ZERO
var pivot
var camera_boom
var vertical_look_angle = 0.0

func _ready():
	pivot = $Pivot
	camera_boom = pivot.get_node("CameraBoom")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		# Yaw (rotate pivot horizontally)
		pivot.rotate_y(-event.relative.x * mouse_sensitivity)

		# Pitch (tilt camera vertically)
		vertical_look_angle = clamp(vertical_look_angle - event.relative.y * mouse_sensitivity, -1.2, 1.2)
		camera_boom.rotation.x = vertical_look_angle

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		target_velocity.y -= fall_acceleration * delta
	else:
		# Jump if space is pressed
		if Input.is_action_just_pressed("jump"):
			target_velocity.y = jump_velocity

	# Movement input
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		var pivot_basis = pivot.global_transform.basis
		var move_direction = (pivot_basis.x * direction.x + pivot_basis.z * direction.z).normalized()
		target_velocity.x = move_direction.x * speed
		target_velocity.z = move_direction.z * speed
	else:
		target_velocity.x = 0
		target_velocity.z = 0
	velocity = target_velocity
	move_and_slide()
