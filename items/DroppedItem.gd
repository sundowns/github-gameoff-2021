extends Spatial

signal touched
signal picked_up

func _on_PlayerDetectionArea_player_entered() -> void:
	emit_signal("touched")


func _on_InteractableArea_triggered() -> void:
	emit_signal("picked_up")
	queue_free()
