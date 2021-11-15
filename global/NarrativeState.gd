extends Node

const narrative_handler_scenepath := "ViewportContainer/Viewport/WorldAnchor/OverworldLevel/SceneNarrativeHandler"

class WorldItem:
	var is_player_holding: bool = false
	var key: String
	var position: Vector3
	var scene_path: String
	func _init(_key, _position, _scene_path):
		key = _key
		position = _position
		scene_path = _scene_path
		is_player_holding = false
	func dropped():
		is_player_holding = false
	func picked_up():
		is_player_holding = true
# Used to check if an item has been picked up
var world_items_cache: Dictionary = {}

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
