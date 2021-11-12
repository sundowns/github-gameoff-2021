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
	timer.start(activate_after)
	player_detect_area.monitoring = false
	interaction_area.monitorable = false
	call_deferred("connect_signals")

func connect_signals():
	var narrative_handler = get_tree().current_scene.get_node(NarrativeState.narrative_handler_scenepath)
# warning-ignore:return_value_discarded
	connect("picked_up", narrative_handler, "item_pickup", [], CONNECT_DEFERRED)
# warning-ignore:return_value_discarded
	connect("touched", narrative_handler, "item_pickup_prompt", [], CONNECT_DEFERRED) 

func _on_PlayerDetectionArea_player_entered() -> void:
	if is_active:
		emit_signal("touched", item_key)

func _on_InteractableArea_triggered() -> void:
	if is_active:
		emit_signal("picked_up", item_key)
		queue_free()

func _on_ActivateAfter_timeout() -> void:
	is_active = true
	player_detect_area.monitoring = true
	interaction_area.monitorable = true
