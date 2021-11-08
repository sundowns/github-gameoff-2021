extends OffsetFollower
class_name CameraMovement

onready var tween: Tween = $Tween

signal movement_tween_finished

enum MovementMode {
	FOLLOW = 0,
	TWEEN = 1
}
var current_mode: int = MovementMode.FOLLOW

func _ready():
	Global.register_pause_subscriber(self, "_on_pause_changed")

func _physics_process(delta: float) -> void:
	if Global.is_paused:
		return
	match current_mode:
		MovementMode.FOLLOW:
			._physics_process(delta)
		MovementMode.TWEEN:
			pass # Do nothing, the tween will handle it

func tween_between_positions(from: Spatial, to: Spatial, duration, transition_type, ease_type):
	current_mode = MovementMode.TWEEN
	global_transform.origin = from.global_transform.origin + offset
# warning-ignore:return_value_discarded
	tween.stop_all()
# warning-ignore:return_value_discarded
	tween.interpolate_property(self, "global_transform:origin", from.global_transform.origin + offset, to.global_transform.origin + offset, duration, transition_type, ease_type)
# warning-ignore:return_value_discarded
	tween.start()

func _on_Tween_tween_all_completed() -> void:
	emit_signal("movement_tween_finished")

func set_follow_target(target):
	current_mode = MovementMode.FOLLOW
	.set_follow_target(target)

func _on_pause_changed(is_paused: bool):
	if is_paused:
# warning-ignore:return_value_discarded
		tween.stop_all()
	else:
# warning-ignore:return_value_discarded
		tween.resume_all()
