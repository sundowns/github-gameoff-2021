extends Spatial
class_name SpeechBubble

export(NarrativeDirector.ALL_SPEAKERS) var character_name

func _ready():
	visible = false
