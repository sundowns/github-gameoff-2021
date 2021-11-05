extends SceneNarrative

func _ready():
# Narrative sequences that react to something in the world - e.g. a button is pressed
# These are triggered by signals connected to the 'SceneNarrativeHandler's 'display_callback' function.
	scene_callbacks = {
		# The name of the callback event
		"lamp_button_prompt": [
			# The sequence of events that happen in reaction to the event
			SceneDialogue.new("peter","[color=white][i]I could use this...[/i][/color]"),
			Wait.new(0.5),
			SceneDialogue.new("peter","[color=white]welp...[/color]"),
		]
	}
	
# The sequence automatically run when the scene loads.
	statements = [
		SceneDialogue.new("peter","[color=red]W[color=yellow]O[color=green]A[color=blue]H [color=white]I'm like - [u]totally[/u] bugging out over here man[/color]"),
		Wait.new(1),
		SceneDialogue.new("jimmy", "[color=green]....[/color]"),
		Wait.new(0.5),
		SceneDialogue.new("jimmy", "[color=green]You can't just say that man[/color]"),
		SceneDialogue.new("timmy", "[color=pink]u guys r starting to piss me off....[/color]"),
	]