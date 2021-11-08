extends Spatial

onready var level_placeholder: Node = $ViewportContainer/Viewport/LevelPlaceHolder
onready var level_container_viewport: Viewport = $ViewportContainer/Viewport

func _ready():
	level_placeholder.call_deferred("load_start_level")
	Global.register_levelchange_subscriber(self, "change_overworld_level")

func change_overworld_level(scene: PackedScene):
	var held_items = []
	var existing_overworld = level_container_viewport.get_child(0)
	if existing_overworld:
		# Grab anything the player is holding and remove from the tree
		var player_items_branch = level_container_viewport.get_node("OverworldLevel/Entities/Player/Hand")
		for child in player_items_branch.get_children():
			player_items_branch.remove_child(child)
			held_items.append(child)
		level_container_viewport.remove_child(existing_overworld)
		existing_overworld.queue_free()
	
	var new_scene = scene.instance()
	level_container_viewport.add_child(new_scene)
	# Give player anything they were holding on load
	for item in held_items:
		var new_player_items_branch = level_container_viewport.get_node("OverworldLevel/Entities/Player/Hand")
		new_player_items_branch.add_child(item)

