extends Node

enum ALL_SPEAKERS { 
	Peter, 
	BugFriend1
}

var current_speech_bubbles = {}

func _ready():
	clear_all_speech_bubbles()

func clear_all_speech_bubbles():
	current_speech_bubbles = {}

func register_new_speech_bubble(new_bubble: SpeechBubble):
	# Add new bubble to the reference map
	current_speech_bubbles[new_bubble.character_name] = new_bubble


# TODO: Move most of this to the scene-specific "SceneNarrativeHandler". Use this to dictate overall game scene flow & constants like "ALL_SPEAKERS" enum
