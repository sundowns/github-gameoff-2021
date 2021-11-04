extends Spatial
class_name SpeechBubble

export(NarrativeDirector.ALL_SPEAKERS) var character_name

signal on_display_finished

func _ready():
	visible = false
	call_deferred("register_self")

func register_self():
	get_tree().current_scene.get_node("SceneNarrativeHandler").register_new_speech_bubble(self)

func display(text: String):
	$SpeechBubbleViewportContainer/Viewport/SpeechBubbleContainer.display_text(text)

func _on_SpeechBubbleContainer_text_finished_displaying() -> void:
	emit_signal("on_display_finished")
