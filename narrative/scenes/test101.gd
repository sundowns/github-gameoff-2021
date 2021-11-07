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
		CameraFollowChangeTween.new("CameraAnchors/DaddysLittleAnchor", 1),
		CameraMotionTween.new("CameraAnchors/DaddysLittleAnchor", "CameraAnchors/DaddysBiggerAnchor", 2, Tween.TRANS_CUBIC, Tween.EASE_IN),
		CameraMotionTween.new("CameraAnchors/DaddysBiggerAnchor", "Triggers/DroppedItem", 1, Tween.TRANS_EXPO, Tween.EASE_IN),
		CameraFollowChangeTween.new("Triggers/DroppedItem", 1),
		Wait.new(0.5),
		SceneDialogue.new("peter","[color=red]W[color=yellow]O[color=green]A[color=blue]H [color=white]what's over there??[/color]"),
		Wait.new(0.5),
		SceneDialogue.new("jimmy", "[color=green]....[/color]", true),
		Wait.new(0.6),
		SceneDialogue.new("jimmy", "[color=green]Are you asking me or what?[/color]"),
		CameraFollowChangeTween.new("Entities/Player", 0.4),
		EndCutscene.new(),
		SceneDialogue.new("timmy", "[color=pink]u guys r starting to piss me off....[/color]"),
	]
