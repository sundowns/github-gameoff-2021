extends Node
class_name SceneNarrativeHandler

signal cutscene_mode_changed(is_enabled)

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
	if Global.is_paused:
		yield(Global, "pause_changed")
	match item.type:
		"wait":
			yield(get_tree().create_timer(item.duration), "timeout")
		"dialogue":
			var speaker = current_speech_bubbles[item.who]
			if speaker:
				speaker.display(item.what)
				if item.end_as_text_ends:
					yield(speaker, "on_text_finished")
				else:
					yield(speaker, "on_display_finished")
		"camera_follow_change":
			var current_scene = get_parent()
			var camera_node = current_scene.get_node("Camera")
			var node_to_follow = current_scene.get_node(item.to)
			if not node_to_follow:
				push_error("Failed to find target to switch camera follow to: %s" % item.to)
			else:
				camera_node.set_follow_target(node_to_follow)
			yield(get_tree().create_timer(item.blocking_duration), "timeout")
		"camera_motion_tween":
			var current_scene = get_parent()
			var from_node = current_scene.get_node(item.from)
			var to_node = current_scene.get_node(item.to)
			if not from_node or not to_node:
				push_error("Failed to find 'from' or 'to' nodes for camera motion tween: %s , %s" % [item.from, item.to])
			else:
				var camera_node = current_scene.get_node("Camera")
				camera_node.tween_between_positions(from_node, to_node, item.duration, item.transition_type, item.ease_type)
				yield(camera_node, "movement_tween_finished")
		"signal_emit":
			pass #find a node by key, then emit a signal. Optionally, deferred
		"start_cutscene":
			emit_signal("cutscene_mode_changed", true)
			yield(get_tree().create_timer(item.blocking_duration), "timeout")
		"end_cutscene":
			emit_signal("cutscene_mode_changed", false)
			yield(get_tree().create_timer(item.blocking_duration), "timeout")
		"item":
			var player = get_parent().get_node("Entities/Player")
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
