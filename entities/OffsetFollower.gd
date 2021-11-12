extends Spatial
class_name OffsetFollower

# Extended from https://github.com/AhmedHamdi1234/Smooth-Camera-Follow-Godot-Demo/blob/main/Scripts/Camera_Follow.gd

export(NodePath) var follow_target_path: NodePath = "Player"
onready var target: Node
export var smooth_speed: float = 3.0
export var offset: Vector3

# warning-ignore:unused_signal
signal target_changed(target)

func _ready():
	# Lazy but ceebs
	yield(get_tree().create_timer(1.0), "timeout")
	call_deferred("look_for_target")

func look_for_target():
	var node = get_node_or_null(follow_target_path)
	if node:
		set_follow_target(node)
		print('found em')
	else:
		push_warning("Node did not exist at path: '%s' in OffsetFollower _ready()" % follow_target_path)

func set_follow_target(_target: Node):
	target = _target
	call_deferred("emit_signal", "target_changed", target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(target != null):
		global_transform.origin = lerp(global_transform.origin, target.global_transform.origin + offset, smooth_speed * delta)
	
