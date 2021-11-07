extends Spatial
class_name Hand

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_held_item"):
		for child in get_children():
			if child is Item:
				child.use()
