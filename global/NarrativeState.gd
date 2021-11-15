extends Node

const narrative_handler_scenepath := "ViewportContainer/Viewport/WorldAnchor/OverworldLevel/SceneNarrativeHandler"

class WorldItem:
	var is_player_holding: bool = false
	var key: String
	var position: Vector3
	var scene_key: String
	var just_dropped: bool = false
	func _init(_key, _position, _scene_key):
		key = _key
		position = _position
		scene_key = _scene_key
		is_player_holding = false
	func dropped(at: Vector3, _scene_key: String):
		is_player_holding = false
		just_dropped = true
		position = at
		scene_key = _scene_key
	func picked_up():
		is_player_holding = true
	func carried_across_world(to_scene_key: String):
		scene_key = to_scene_key
# Used to check if an item has been picked up
var world_items_cache: Dictionary = {}

func item_dropped(key: String, at: Vector3):
	var narrative_handler = get_tree().current_scene.get_node(narrative_handler_scenepath)
	world_items_cache[key].dropped(at, narrative_handler.narrative.scene_key)

class PlayerCompanion:
	var key: String
	var scene_path: String
	func _init(_key: String, _scene_path: String):
		key=_key
		scene_path=_scene_path

var all_companions := {
	"jimmy": PlayerCompanion.new("jimmy", "res://entities/LilJimmy.tscn"),
	"timmy": PlayerCompanion.new("timmy", "res://entities/TinyTimmy.tscn")
}

var current_companions = ["timmy"]

func add_companion(companion_key: String):
	for current in current_companions:
		if current == companion_key:
			push_warning("Tried to add existing companion")
			return
	current_companions.append(companion_key)

func remove_companion(companion_key: String):
	for current in current_companions:
		if current == companion_key:
			current_companions.remove(current)
			return
