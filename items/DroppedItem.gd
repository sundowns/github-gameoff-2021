extends Spatial

signal touched
signal picked_up

export(float) var activate_after := 1.0
onready var timer: Timer = $ActivateAfter
onready var player_detect_area: Area = $PlayerDetectionArea
onready var interaction_area: Area = $InteractableArea
var is_active := false

func _ready():
	timer.start(activate_after)
	player_detect_area.monitoring = false
	interaction_area.monitorable = false

func _on_PlayerDetectionArea_player_entered() -> void:
	if is_active:
		emit_signal("touched")

func _on_InteractableArea_triggered() -> void:
	if is_active:
		emit_signal("picked_up")
		queue_free()

func _on_ActivateAfter_timeout() -> void:
	is_active = true
	player_detect_area.monitoring = true
	interaction_area.monitorable = true
