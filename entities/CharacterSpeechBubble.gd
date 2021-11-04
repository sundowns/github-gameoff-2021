extends Spatial
class_name SpeechBubble

export(NarrativeManager.ALL_SPEAKERS) var character_name

func _ready():
	visible = false
