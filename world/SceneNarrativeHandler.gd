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
	var peter = current_speech_bubbles[NarrativeDirector.ALL_SPEAKERS.Peter]
	peter.display("[color=red]I'm GAMING out here and i l-l-love it!!!![/color]")
	print(peter)
	yield(peter, "on_display_finished")
	print(peter)
	print('we yielded dayum')
	peter.display("[color=green]You tryna throw down or what??[/color]")
	yield(peter, "on_display_finished")
	print('shee')
