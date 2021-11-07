extends Spatial

onready var level_placeholder: Node = $ViewportContainer/Viewport/LevelPlaceHolder

func _ready():
	level_placeholder.call_deferred("load_start_level")
