extends Spatial

signal touched(key)
signal picked_up(key)

export(String) var item_key := "flashlight"
export(float) var activate_after := 1.0
onready var timer: Timer = $ActivateAfter
onready var player_detect_area: Area = $PlayerDetectionArea
onready var interaction_area: Area = $InteractableArea
var is_active := false

func _ready():
	player_detect_area.monitoring = false
	interaction_area.monitorable = false
	call_deferred("initialise")

func initialise():
	var narrative_handler = get_tree().current_scene.get_node(NarrativeState.narrative_handler_scenepath)
	if not narrative_handler:
		push_error("Item failed to find narrative handler to handle spawning logic.")
	# Lookup global world cache with our key
	if NarrativeState.world_items_cache.has(item_key):
		var existing_world_item = NarrativeState.world_items_cache[item_key]
		if (not existing_world_item.scene_path == narrative_handler.narrative.scene_key) or existing_world_item.is_player_holding:
			# If it exists and is in another area or on player, queue_free this one
			queue_free()
			print('dont spawn this one')
			return
		else:
			# If it exists and is in this area, move it to its dropped position
			global_transform.origin = existing_world_item.position
			print('it belong here, moving it to position: ', existing_world_item.position)
		pass
	else:
		# If it does not exist, add this entry to it 
		print('adding to item cache')
		NarrativeState.world_items_cache[item_key] = NarrativeState.WorldItem.new(item_key, global_transform.origin, narrative_handler.narrative.scene_key)
	
	timer.start(activate_after)
	call_deferred("connect_signals", narrative_handler)

func connect_signals(narrative_handler):
#	var narrative_handler = get_tree().current_scene.get_node(NarrativeState.narrative_handler_scenepath)
# warning-ignore:return_value_discarded
	connect("picked_up", narrative_handler, "item_pickup", [], CONNECT_DEFERRED)
# warning-ignore:return_value_discarded
	connect("touched", narrative_handler, "item_pickup_prompt", [], CONNECT_DEFERRED) 

func _on_PlayerDetectionArea_player_entered() -> void:
	if is_active:
		emit_signal("touched", item_key)

func _on_InteractableArea_triggered() -> void:
	if is_active:
		var narrative_handler = get_tree().current_scene.get_node(NarrativeState.narrative_handler_scenepath)
		if not narrative_handler:
			push_error("Item failed to find narrative handler to handle pickup logic for world item cache.")
		else:
			NarrativeState.world_items_cache[item_key].picked_up()
		emit_signal("picked_up", item_key)
		queue_free()

func _on_ActivateAfter_timeout() -> void:
	is_active = true
	player_detect_area.monitoring = true
	interaction_area.monitorable = true
