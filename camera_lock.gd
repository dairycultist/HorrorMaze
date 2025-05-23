extends Camera3D

@export var anchor: Node3D

func _process(delta: float) -> void:
	global_position = anchor.global_position
	global_rotation = anchor.global_rotation
