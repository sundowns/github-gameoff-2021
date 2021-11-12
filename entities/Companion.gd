extends KinematicBody
class_name Companion

onready var forward_raycast: RayCast = $ForwardLowerRayCast
onready var overhead_raycast: RayCast = $ForwardOverheadRayCast

export(NodePath) var follow_target_path = "Player"
var follow_target: Node

const FLOOR_NORMAL = Vector3(0.0, 1.0, 0.0)
# Kind of a hack and probably only works with specific floor heights
const step_up_velocity := 6.0

var velocity_y := 0.0
var is_following := false
export(float) var min_follow_distance := 1.0
export(float) var catchup_follow_distance := 3.0
export(float) var teleport_catchup_distance := 10.0
const distance_to_teleport_to_from_follow_target := 6.0

export(float) var speed := 6.0
export(float) var catchup_speed := 8.0
export(float) var gravity := 30.0

func set_target(_target: Node):
	follow_target = _target
	is_following = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity_y -= gravity * delta
	if follow_target and is_following:
		look_at(Vector3(follow_target.global_transform.origin.x, global_transform.origin.y, follow_target.global_transform.origin.z), FLOOR_NORMAL)
		move_to_target(delta)
	if is_on_floor() or is_on_ceiling():
		velocity_y = 0.0

func move_to_target(_delta: float):
	var to_target: Vector3 = follow_target.global_transform.origin - global_transform.origin
	var distance_to_target: float = to_target.length()
	var direction := to_target.normalized()
	
	if is_on_floor() and forward_raycast.is_colliding():
		velocity_y = step_up_velocity
	
	var effective_speed = speed
	if distance_to_target > catchup_follow_distance:
		effective_speed = catchup_speed 
	
	var velocity = Vector3(
		direction.x * effective_speed,
		velocity_y,
		direction.z * effective_speed)
		
	if distance_to_target < min_follow_distance:
		velocity.x = 0
		velocity.z = 0
	
# warning-ignore:return_value_discarded
	move_and_slide(velocity, FLOOR_NORMAL)
	
	if is_on_floor() or is_on_ceiling():
		velocity_y = 0.0
	
	# unstuck target
	if distance_to_target > teleport_catchup_distance:
		var new_position = follow_target.global_transform.origin + -direction * distance_to_teleport_to_from_follow_target
		global_transform.origin = new_position
