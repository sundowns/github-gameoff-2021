extends Node
class_name SceneNarrativeHandler

onready var narrative = $Narrative
onready var animation_player: AnimationPlayer = $AnimationPlayer

export(bool) var narrative_disabled := false
export(bool) var callbacks_disabled := false

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
	if narrative_disabled:
		return
	narrative.emit_signal("narrative_started")
	for item in narrative.statements:
		yield(handle_narrative_item(item), "completed")
	narrative.emit_signal("narrative_concluded")

func display_callback(dialogue_key: String):
	if callbacks_disabled:
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
		"item":
			var player = get_tree().current_scene.get_node("Entities/Player")
			player.pickup_item(load(item.item_scene_path).instance())
			yield(player, "item_picked_up")
		"animation":
			if not animation_player.has_animation(item.animation_key):
				push_error("Tried to play non existent animation key: %s" % item.animation_key)
			else:
				animation_player.play(item.animation_key)
				if item.wait_to_finish:
					yield(animation_player, "animation_finished")
				else:
					yield(get_tree().create_timer(0.05), "timeout")
