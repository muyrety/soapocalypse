extends CharacterBody3D

@export var shrink_rate := 0.05
@export var move_speed := 5.0

var shrink_timer := 0.0
var is_dead := false

func _physics_process(delta):
	if is_dead:
		return
	
	var input = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	
	var cam_basis = get_viewport().get_camera_3d().global_transform.basis
	var move_dir = (cam_basis.x * input.x + cam_basis.z * input.y).normalized()
	
	velocity = move_dir * move_speed
	move_and_slide()

	# Shrink logic
	shrink_timer += delta
	if shrink_timer > 1.0:
		shrink()
		shrink_timer = 0.0

func shrink():
	scale *= 0.98
	if scale.x < 0.2:
		die()

func die():
	is_dead = true
	set_physics_process(false)
	# Signal to main scene
	get_tree().call_group("game", "on_player_died")
