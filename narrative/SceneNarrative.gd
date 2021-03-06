extends Node
class_name SceneNarrative

export(String) var scene_key := "A1"

class NarrativeItem:
	var type: String = "base"

class Wait extends NarrativeItem:
	var duration: float = 1.0
	func _init(_duration):
		type="wait"
		duration=_duration

class SceneDialogue extends NarrativeItem:
	var who: String = "peter"
	var what: String = ""
	var end_as_text_ends: bool = false # If false, waits a small period after typing the last character. If true, ends on the last character
	func _init(_who, _what, _end_as_text_ends=false):
		type="dialogue"
		who=_who
		what=_what
		end_as_text_ends = _end_as_text_ends

class StartCutscene extends NarrativeItem:
	var blocking_duration = 0.05
	func _init(_blocking_duration = 0.05):
		type="start_cutscene"
		blocking_duration = _blocking_duration

class EndCutscene extends NarrativeItem:
	var blocking_duration = 0.05
	func _init(_blocking_duration = 0.05):
		type="end_cutscene"
		blocking_duration = _blocking_duration

class CameraMotionTween extends NarrativeItem:
	var duration: float = 1.0
	var from: NodePath
	var to: NodePath
	var transition_type: int = 0
	var ease_type: int = 2
	func _init(_from, _to, _duration = 1.0, _transition_type = 0, _ease_type = 2):
		type="camera_motion_tween"
		duration=_duration
		from=_from
		to=_to
		transition_type=_transition_type
		ease_type=_ease_type

class CameraFollowChangeTween extends NarrativeItem:
	var to: NodePath
	var blocking_duration: float = 0.0
	func _init(_to, _blocking_duration = 0.0):
		type="camera_follow_change"
		to=_to
		blocking_duration = _blocking_duration

# not implemented yet
class SignalEmission extends NarrativeItem:
	var node_path: NodePath
	var signal_name: String
	func _init(_node_path, _signal_name):
		type="signal"
		node_path=_node_path
		signal_name=_signal_name

class ItemPickup extends NarrativeItem:
	var item_scene_path: String
	func _init(_item_scene_path):
		type="item"
		item_scene_path=_item_scene_path

class AnimationPlayerSequence extends NarrativeItem:
	var animation_key: String
	var wait_to_finish: bool = false
	func _init(_key, _wait_to_finish):
		type="animation"
		animation_key = _key
		wait_to_finish = _wait_to_finish

# warning-ignore:unused_signal
signal narrative_concluded
# warning-ignore:unused_signal
signal narrative_started

var scene_callbacks = {}
var statements := []
var universal_callbacks = {
	"_flashlight_pickup_prompt" : [
			SceneDialogue.new("peter","[color=white]oooo a torch![/color]")
		],
	"_flashlight_pickup": [
		ItemPickup.new("res://items/Flashlight.tscn")
	],
	"_bugspray_pickup": [
		ItemPickup.new("res://items/BugSpray.tscn")
	]
}

func _ready():
	scene_callbacks = {}
	load_callbacks()
	load_narrative_statements()

func load_callbacks() -> void:
	pass

func load_narrative_statements() -> void:
	pass
