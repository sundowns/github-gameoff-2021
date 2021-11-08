extends Spatial

onready var level_placeholder: Node = $ViewportContainer/Viewport/LevelPlaceHolder
onready var level_container_viewport: Viewport = $ViewportContainer/Viewport

func _ready():
	level_placeholder.call_deferred("load_start_level")
	Global.register_levelchange_subscriber(self, "change_overworld_level")

func change_overworld_level(scene: PackedScene):
	print('loading new level: %s' % scene)

	var existing_overworld = level_container_viewport.get_child(0)
	if existing_overworld:
		level_container_viewport.remove_child(existing_overworld)
		existing_overworld.queue_free()
	
	var new_scene = scene.instance()
	level_container_viewport.add_child(new_scene)


#func load_world(new_world_scene: PackedScene):
#	# unload currently loaded world if it exists
#	if current_world:
#		remove_child(current_world)
#		current_world.queue_free()
#		current_world = null
#	current_world = new_world_scene.instance()
#	add_child(current_world)

#func unload_existing_level():
#	for child in level_container_viewport.get_children():
#		print(child)
#		child.queue_free()
