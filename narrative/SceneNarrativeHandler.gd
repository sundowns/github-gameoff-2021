extends Node
class_name SceneNarrativeHandler

onready var narrative = $Narrative

var current_speech_bubbles = {}

func _ready():
	clear_all_speech_bubbles()

func clear_all_speech_bubbles():
	current_speech_bubbles = {}

func register_new_speech_bubble(new_bubble):
	# Add new bubble to the reference map
	current_speech_bubbles[new_bubble.character_name] = new_bubble

func _on_StartDelay_timeout() -> void:
	run_scene_script()

func run_scene_script():
	for item in narrative.statements:
		yield(handle_narrative_item(item), "completed")

func display_callback(dialogue_key: String):
	var dialogue_items = narrative.scene_callbacks[dialogue_key]
	for item in dialogue_items:
		yield(handle_narrative_item(item), "completed")

func handle_narrative_item(item):
	match item.type:
		"wait":
			yield(get_tree().create_timer(item.duration), "timeout")
		"dialogue":
			var speaker = current_speech_bubbles[item.who]
			if speaker:
				speaker.display(item.what)
				yield(speaker, "on_display_finished")
		"camera_follow_change":
			pass
		"camera_motion_tween":
			pass
		"signal_emit":
			pass
