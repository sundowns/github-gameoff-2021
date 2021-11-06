extends Node
class_name SceneNarrative

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
	func _init(_who, _what):
		type="dialogue"
		who=_who
		what=_what

class CameraMotionTween extends NarrativeItem:
	var duration: float = 0.0
	var from: Transform
	var to: Transform
	func _init(_duration, _from, _to):
		type="camera_motion_tween"
		duration=_duration
		from=_from
		to=_to

class CameraFollowChangeTween extends NarrativeItem:
	var blocking_duration: float = 0.0
	var from: Node
	var to: Node
	func _init(_duration, _from, _to):
		type="camera_follow_change"
		from=_from
		to=_to

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

# warning-ignore:unused_signal
signal narrative_concluded
# warning-ignore:unused_signal
signal narrative_started

var scene_callbacks = {}
var statements := []

func _ready():
	scene_callbacks = {}
	load_callbacks()
	load_narrative_statements()

func load_callbacks() -> void:
	pass

func load_narrative_statements() -> void:
	pass
