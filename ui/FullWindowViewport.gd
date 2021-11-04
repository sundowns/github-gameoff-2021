extends ViewportContainer
class_name FullWindowViewport

onready var viewport = $Viewport

func _ready():
# warning-ignore:return_value_discarded
	get_tree().root.connect("size_changed", self, "_on_window_size_changed")

func _on_window_size_changed():
	var new_window_size = get_viewport().get_visible_rect().size
	self.rect_size = new_window_size
	viewport.size = new_window_size
