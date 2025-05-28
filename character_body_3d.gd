extends CharacterBody3D

@export var move_speed := 5.0
@export var shrink_rate := 0.05

var is_dead := false

func _physics_process(_delta):  # Fixed unused 'delta' warning by renaming to _delta
	if is_dead:
		return

	# Get input direction (WASD / Arrow keys)
	var input_dir := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	).normalized()

	if input_dir != Vector2.ZERO:
		# Get camera direction vectors
		var camera := get_viewport().get_camera_3d()
		var forward := -camera.global_transform.basis.z.normalized()
		var right := camera.global_transform.basis.x.normalized()

		# Move in the direction relative to camera
		var move_vector := (right * input_dir.x + forward * input_dir.y).normalized()
		velocity = move_vector * move_speed
	else:
		velocity = Vector3.ZERO

	move_and_slide()
