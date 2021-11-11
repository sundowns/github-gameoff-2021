extends Spatial

onready var camera: Camera = $Camera
onready var player_spawn_point: PlayerSpawnPoint = $Entities/PlayerSpawnPoint
onready var narrative_handler: SceneNarrativeHandler = $SceneNarrativeHandler

var player: Player = null

const mouse_look_ray_length := 10000

export(int, LAYERS_3D_PHYSICS) var mouse_collision_mask

func _ready():
	call_deferred('connect_signals')
	call_deferred('setup_scene')

func setup_scene():
	player = player_spawn_point.spawn()
	camera.set_follow_target(player)
	yield(player_spawn_point, "spawned")
	narrative_handler.start()

func _physics_process(_delta: float) -> void:
	if player and not player.is_frozen:
		var space_state = get_world().direct_space_state
		var mouse_position = get_viewport().get_mouse_position()
		
		var ray_origin = camera.project_ray_origin(mouse_position)
		var ray_end = ray_origin + camera.project_ray_normal(mouse_position) * mouse_look_ray_length
		
		var intersection = space_state.intersect_ray(ray_origin, ray_end, [], mouse_collision_mask)
		
		if not intersection.empty():
			player.point_hand_at(intersection.position)
		

func connect_signals():
	Global.register_pause_subscriber(self, "_on_pause_changed")

func _on_pause_changed(new_value):
	get_tree().paused = new_value
