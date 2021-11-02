extends Sprite3D

onready var raycast: RayCast = $RayCast

const vertical_offset = 0.05

func _physics_process(delta: float) -> void:
	if raycast.is_colliding():
		global_transform.origin.y = raycast.get_collision_point().y + vertical_offset
