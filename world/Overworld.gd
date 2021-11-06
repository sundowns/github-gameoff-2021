extends Spatial

onready var camera: Camera = $Camera

onready var player = $Entities/Player

const mouse_look_ray_length := 10000

func _physics_process(delta: float) -> void:
	if player:
		var space_state = get_world().direct_space_state
		var mouse_position = get_viewport().get_mouse_position()
		
		var ray_origin = camera.project_ray_origin(mouse_position)
		var ray_end = ray_origin + camera.project_ray_normal(mouse_position) * mouse_look_ray_length
		
		var intersection = space_state.intersect_ray(ray_origin, ray_end)
		
		if not intersection.empty():
			player.point_hand_at(intersection.position)
		
