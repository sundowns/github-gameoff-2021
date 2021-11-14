extends Spatial
class_name OverworldScene

onready var camera: Camera = $Camera
onready var player_spawn_point: PlayerSpawnPoint = $Entities/PlayerSpawnPoint
onready var narrative_handler: SceneNarrativeHandler = $SceneNarrativeHandler

var player: Player = null

const mouse_look_ray_length := 10000

export(int, LAYERS_3D_PHYSICS) var mouse_collision_mask

signal scene_initialised

func _ready():
	call_deferred('connect_signals')

const companion_spawn_offset_distance := 2.0
const companion_spawn_directions := [Vector2.UP,Vector2.RIGHT,Vector2.DOWN,Vector2.LEFT]

func setup_scene(spawn_zone_key: String = ""):
	player_spawn_point.spawn()
	yield(player_spawn_point, "spawned")
	player = get_node("Entities/Player")
	if spawn_zone_key != "":
		move_player_to_transition_zone(spawn_zone_key)
	# Spawn companions - iterate through the offset directions, so they spawn around a player atm
	spawn_current_companions()
# warning-ignore:return_value_discarded
	narrative_handler.connect("cutscene_mode_changed", player, "_on_SceneNarrativeHandler_cutscene_mode_changed")
	camera.set_follow_target(player)
	
	for entity in $Entities.get_children():
		if entity is OffsetFollower:
			entity.look_for_target()
	for light in $Lights.get_children():
		if light is OffsetFollower:
			light.look_for_target()

	yield(get_tree().create_timer(0.05), "timeout")
	emit_signal("scene_initialised")
	narrative_handler.start()

func spawn_current_companions():
	assert(player != null, "Where my spawned player at??????????")
	var direction_array_index := 0 
	var target_to_follow = player
	for companion_key in NarrativeState.current_companions:
		var companion_data = NarrativeState.all_companions[companion_key]
		var direction = companion_spawn_directions[direction_array_index]
		direction_array_index += 1
		var companion = load(companion_data.scene_path).instance()
		get_node("Entities").add_child(companion)
		companion.global_transform.origin = player.global_transform.origin + Vector3(direction.x, 0, direction.y) * companion_spawn_offset_distance
		companion.set_target(target_to_follow)
		target_to_follow = companion

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

func move_player_to_transition_zone(transition_zone_key: String):
	if not player:
		return
	for trigger in $Triggers.get_children():
		if trigger is OverworldTransitionZone:
			if trigger.key == transition_zone_key:
				player.global_transform.origin = trigger.spawn_position.global_transform.origin
