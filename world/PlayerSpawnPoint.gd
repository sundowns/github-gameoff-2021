extends Position3D
class_name PlayerSpawnPoint

export(PackedScene) var scene: PackedScene = preload("res://player/Player.tscn")

signal spawned

func _ready():
	spawn()

func spawn():
	var new_spawned = scene.instance()
	get_parent().call_deferred("add_child", new_spawned)
	new_spawned.global_transform = global_transform
	new_spawned.rotation = rotation
	call_deferred("finished")

func finished():
	emit_signal("spawned")
	queue_free()
