extends Node3D

@export var follow_target: NodePath
@export var smooth_speed := 5.0
@export var offset := Vector3(0, 3, -6)

var target = null

func _ready():
	target = get_node(follow_target)

func _process(delta):
	if target:
		global_position = global_position.lerp(target.global_position + offset, delta * smooth_speed)
		look_at(target.global_position, Vector3.UP)
