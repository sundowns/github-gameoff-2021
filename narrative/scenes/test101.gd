extends SceneNarrative

func _ready():
# Narrative sequences that react to something in the world - e.g. a button is pressed
# These are triggered by signals connected to the 'SceneNarrativeHandler's 'display_callback' function.
	scene_callbacks = {
		# The name of the callback event
		"lamp_button_prompt": [
			# The sequence of events that happen in reaction to the event
			AnimationPlayerSequence.new("SpinThing", false),
			SceneDialogue.new("peter","[color=white][i]I could use this...[/i][/color]"),
		],
		"flashlight_pickup_prompt" : [
			SceneDialogue.new("peter","[color=white]oooo a torch![/color]")
		],
		"flashlight_pickup": [
			ItemPickup.new("res://items/Flashlight.tscn")
		]
	}
	
# This sequence automatically run when the scene loads.
	statements = [
		StartCutscene.new(),
		CameraFollowChangeTween.new("Triggers/DroppedItem", 1),
		SceneDialogue.new("peter","[color=red]W[color=yellow]O[color=green]A[color=blue]H [color=white]what's over there??[/color]"),
		Wait.new(0.5),
		CameraFollowChangeTween.new("Entities/Player", 1.0),
		SceneDialogue.new("jimmy", "[color=green]....[/color]", true),
		Wait.new(0.8),
		SceneDialogue.new("jimmy", "[color=green]Are you asking me or what?[/color]"),
		Wait.new(0.5),
		EndCutscene.new(),
		SceneDialogue.new("timmy", "[color=pink]u guys r starting to piss me off....[/color]"),
	]
