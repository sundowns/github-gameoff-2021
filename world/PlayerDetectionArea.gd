extends Area

onready var timer: Timer = $ReactivationDelay

signal player_entered
signal player_exited

export(bool) var one_shot := false
var has_been_triggered := false

var has_been_exited := false

export(bool) var is_disabled := false 

var was_recently_activated := false
export(float) var reactivation_lockout := 0.1

func on_player_entered(body: Node) -> void:
	if is_disabled or was_recently_activated:
		return
	if not body.is_in_group("Player"):
		return
	if not one_shot or (one_shot and has_been_triggered):
		has_been_triggered = true
		emit_signal("player_entered")
		was_recently_activated = true
		timer.start(reactivation_lockout)

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

func _on_ReactivationDelay_timeout() -> void:
	was_recently_activated = false
