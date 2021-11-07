extends Spatial

onready var camera: Camera = $Camera

onready var player = $Entities/Player

const mouse_look_ray_length := 10000

export(int, LAYERS_3D_PHYSICS) var mouse_collision_mask

func _ready():
	call_deferred('connect_signals')
#	connect_signals()

func _physics_process(_delta: float) -> void:
	if player:
		var space_state = get_world().direct_space_state
		var mouse_position = get_viewport().get_mouse_position()
		
		var ray_origin = camera.project_ray_origin(mouse_position)
		var ray_end = ray_origin + camera.project_ray_normal(mouse_position) * mouse_look_ray_length
		
		var intersection = space_state.intersect_ray(ray_origin, ray_end, [], mouse_collision_mask)
		
		if not intersection.empty():
			player.point_hand_at(intersection.position)
		

func connect_signals():
	Global.register_subscriber(self, "_on_pause_changed")

func _on_pause_changed(new_value):
	get_tree().paused = new_value
