extends Node

export(PackedScene) var start_level: PackedScene

func load_start_level():
	var level = start_level.instance()
	replace_by(level)
	call_deferred("queue_free")
