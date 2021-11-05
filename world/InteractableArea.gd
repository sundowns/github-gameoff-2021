extends Area
class_name InteractableArea

signal triggered

export(bool) var one_shot := false
var has_been_triggered := false

export(bool) var is_disabled := false

func trigger():
	if can_be_used():
		emit_signal("triggered")
		has_been_triggered = true

func can_be_used() -> bool:
	return (not is_disabled) and (not one_shot or (one_shot and not has_been_triggered))

func disable():
	is_disabled = true

func enable():
	is_disabled = false
