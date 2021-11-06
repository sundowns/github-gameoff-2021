extends Node
class_name SceneNarrativeHandler

onready var narrative = $Narrative

export(bool) var disabled := false

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
	if disabled:
		return
	for item in narrative.statements:
		yield(handle_narrative_item(item), "completed")

func display_callback(dialogue_key: String):
	if disabled:
		return
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
			pass #Change follow target on the camera script
		"camera_motion_tween":
			pass #Might be a YAGNI on this one for now, probably will be useful but not sure how to do
		"signal_emit":
			pass #find a node by key, then emit a signal. Optionally, deferred
		"start_cutscene":
			pass #take control from player
		"end_cutscene":
			pass #return control to player
