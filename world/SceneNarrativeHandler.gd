extends Node

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
	scene_narrative()
	# Prolly some other stuff like end-of-scene's narrative signal

# Overridable function for scene dialogue? idk
func scene_narrative():
	var peter = current_speech_bubbles["peter"]
	peter.display("[color=red]I'm GAMING out here and i l-l-love it!!!![/color]")
	yield(peter, "on_display_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	peter.display("[color=green]You tryna throw down or what??[/color]")
	yield(peter, "on_display_finished")

class SceneDialogue:
	var who: String = "peter"
	var what: String = ""
	func _init(_who, _what):
		who=_who
		what=_what

var scene_dialogue = {
	"button_prompt": SceneDialogue.new("peter", "[color=white]I could use this...[/color]")
}

func display_callback(dialogue_key: String):
	var dialogue: SceneDialogue = scene_dialogue[dialogue_key]
	var speaker = current_speech_bubbles[dialogue.who]
	if speaker:
		speaker.display(dialogue.what)
		yield(speaker, "on_display_finished")
