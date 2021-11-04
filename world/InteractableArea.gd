extends Area
class_name InteractableArea

signal triggered

export(bool) var one_shot := false
var has_been_triggered := false

func trigger():
	if not one_shot or (one_shot and has_been_triggered):
		emit_signal("triggered")
		has_been_triggered = true
