extends Node

var is_paused := false

signal pause_changed(is_paused)

func register_subscriber(subscriber: Node, function_name: String):
# warning-ignore:return_value_discarded
	connect("pause_changed", subscriber, function_name, [], CONNECT_DEFERRED)

func toggle_pause():
	is_paused = not is_paused
	emit_signal("pause_changed", is_paused)
