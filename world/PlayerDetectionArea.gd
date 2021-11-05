extends Area

signal player_entered
signal player_exited

export(bool) var one_shot := false
var has_been_triggered := false

var has_been_exited := false

export(bool) var is_disabled := false 

func on_player_entered(body: Node) -> void:
	if is_disabled:
		return
	if not body.is_in_group("Player"):
		return
	if not one_shot or (one_shot and has_been_triggered):
		has_been_triggered = true
		emit_signal("player_entered")

func on_player_exited(body: Node) -> void:
	if is_disabled:
		return
	if not body.is_in_group("Player"):
		return
	if not one_shot or (one_shot and has_been_exited):
		has_been_exited = true
		emit_signal("player_exited")

func disable():
	is_disabled = true

func enable():
	is_disabled = false
