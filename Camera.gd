extends Camera

# Extended from https://github.com/AhmedHamdi1234/Smooth-Camera-Follow-Godot-Demo/blob/main/Scripts/Camera_Follow.gd

export var follow_target_path: NodePath = "Player"
onready var target: Object = get_parent().get_node(follow_target_path)
export var smooth_speed: float
export var offset: Vector3

func set_follow_target(_target: Node):
	target = _target

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	print('?')
	if(target != null):
		print('move')
		self.translation = lerp(self.translation, target.translation + offset, smooth_speed * delta)
