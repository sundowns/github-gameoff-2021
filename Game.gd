extends Spatial

onready var level_placeholder: Node = $ViewportContainer/Viewport/WorldAnchor/LevelPlaceHolder
onready var world_anchor: Spatial = $ViewportContainer/Viewport/WorldAnchor
onready var loading_animation_player: AnimationPlayer = $LoadingAnimationPlayer
onready var loading_camera: Camera = $ViewportContainer/Viewport/LoadingCamera

func _ready():
	level_placeholder.call_deferred("load_start_level")
	Global.register_levelchange_subscriber(self, "change_overworld_level")
#	loading_animation_player.play_backwards("WorldSlideOut")

func change_overworld_level(scene: PackedScene):
	var held_items = []
	var existing_overworld = world_anchor.get_child(0)
	if existing_overworld:
		var player_node = world_anchor.get_node("OverworldLevel/Entities/Player")
		player_node.freeze()
		var overworld_camera: Camera = world_anchor.get_node("OverworldLevel/Camera")
		loading_camera.global_transform = overworld_camera.global_transform
		loading_camera.rotation = overworld_camera.rotation
		loading_camera.visible = true
		loading_camera.make_current()
		loading_animation_player.play("WorldSlideOut")
		yield(loading_animation_player, "animation_finished")
		# Grab anything the player is holding and remove from the tree
		var player_items_branch = player_node.get_node("Hand")
		for child in player_items_branch.get_children():
			player_items_branch.remove_child(child)
			held_items.append(child)
		world_anchor.remove_child(existing_overworld)
		existing_overworld.queue_free()
	
	var new_scene = scene.instance()
	world_anchor.add_child(new_scene)
	# Give player anything they were holding on load
	for item in held_items:
		var new_player_items_branch = world_anchor.get_node("OverworldLevel/Entities/Player/Hand")
		new_player_items_branch.add_child(item)
	# Slide world back in
	var overworld_camera: Camera = world_anchor.get_node("OverworldLevel/Camera")
	overworld_camera.make_current()
	loading_camera.visible = false
	loading_animation_player.play_backwards("WorldSlideOut")
	yield(loading_animation_player,"animation_finished")
