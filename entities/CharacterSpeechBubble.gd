extends Spatial
class_name SpeechBubble

export(String) var character_name

signal on_display_finished
signal on_text_finished

func _ready():
	visible = false
	character_name = character_name.to_lower()
	call_deferred("register_self")

func register_self():
	get_tree().current_scene.get_node(NarrativeState.narrative_handler_scenepath).register_new_speech_bubble(self)

func display(text: String):
	visible = true
	$Viewport/SpeechBubbleContainer.display_text(text)

func _on_SpeechBubbleContainer_text_finished_displaying() -> void:
	emit_signal("on_text_finished")

func _on_SpeechBubbleContainer_speech_bubble_closing() -> void:
	emit_signal("on_display_finished")
