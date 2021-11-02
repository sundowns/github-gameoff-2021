extends Camera

# Extended from https://github.com/AhmedHamdi1234/Smooth-Camera-Follow-Godot-Demo/blob/main/Scripts/Camera_Follow.gd

export var follow_target_path: NodePath = "Player"
onready var target: Node
export var smooth_speed: float
export var offset: Vector3

func _ready():
	set_follow_target(get_node(follow_target_path))

func set_follow_target(_target: Node):
	target = _target

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(target != null):
		global_transform.origin = lerp(global_transform.origin, target.global_transform.origin + offset, smooth_speed * delta)
