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

# Overridable function for scene dialogue
#https://docs.godotengine.org/en/stable/tutorials/gui/bbcode_in_richtextlabel.html
func scene_narrative():
	var peter = current_speech_bubbles["peter"]
	var jimmy = current_speech_bubbles["jimmy"]
	var timmy = current_speech_bubbles["timmy"]
	
	peter.display("[color=red]W[color=yellow]O[color=green]A[color=blue]H [color=white]I'm like - [u]totally[/u] bugging out over here man[/color]")
	yield(peter, "on_display_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	
	jimmy.display("[color=green]....[/color]")
	yield(jimmy, "on_display_finished")
	yield(get_tree().create_timer(1.0), "timeout")
	jimmy.display("[color=green]You can't just say that man[/color]")
	yield(jimmy, "on_display_finished")
	yield(get_tree().create_timer(0.5), "timeout")
	timmy.display("[color=pink]u guys r starting to piss me off....[/color]")
	yield(timmy, "on_display_finished")

class SceneDialogue:
	var who: String = "peter"
	var what: String = ""
	func _init(_who, _what):
		who=_who
		what=_what

var scene_dialogue = {
	"button_prompt": SceneDialogue.new("peter", "[color=white][i]I could use this...[/i][/color]")
}

func display_callback(dialogue_key: String):
	var dialogue: SceneDialogue = scene_dialogue[dialogue_key]
	var speaker = current_speech_bubbles[dialogue.who]
	if speaker:
		speaker.display(dialogue.what)
		yield(speaker, "on_display_finished")
