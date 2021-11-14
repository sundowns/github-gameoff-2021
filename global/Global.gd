extends Node

const overworld_node_scenepath := "ViewportContainer/Viewport/WorldAnchor/OverworldLevel"

var is_paused := false
var is_debug := true

signal pause_changed(is_paused)
signal overworld_level_changed(new_level)

func register_pause_subscriber(subscriber: Node, function_name: String):
# warning-ignore:return_value_discarded
	connect("pause_changed", subscriber, function_name, [], CONNECT_DEFERRED)

func register_levelchange_subscriber(subscriber: Node, function_name: String):
# warning-ignore:return_value_discarded
	connect("overworld_level_changed", subscriber, function_name, [], CONNECT_DEFERRED)

func toggle_pause():
	is_paused = not is_paused
	emit_signal("pause_changed", is_paused)

func request_level_change(new_level: PackedScene):
	emit_signal("overworld_level_changed", new_level)
