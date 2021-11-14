extends Node

export(PackedScene) var start_level: PackedScene

func load_start_level():
	var level = start_level.instance()
	replace_by(level)
	level.call_deferred("setup_scene")
	call_deferred("queue_free")
