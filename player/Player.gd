extends KinematicBody
class_name Player

# Extended from https://github.com/GDQuest/godot-demos/blob/master/2019/03-23-z-axis-in-2d/src/Godette.gd

const FLOOR_NORMAL = Vector3(0.0, 1.0, 0.0)

export var speed := 7.0
export var gravity := 30.0
export var jump_force := 6.0

var velocity_y := 0.0

var current_interactable_area: InteractableArea = null
onready var interactable_marker: Sprite3D = $CanInteractWithShitIndicator
export(float) var interaction_marker_rotation_speed := 5.0


func _physics_process(delta: float) -> void:
	var direction_ground := Vector3(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"), 0).normalized()
	
	if not is_on_floor():
		velocity_y -= gravity * delta
	
	var velocity = Vector3(
		direction_ground.x * speed,
		velocity_y,
		direction_ground.y * speed)
# warning-ignore:return_value_discarded
	move_and_slide(velocity, FLOOR_NORMAL)
	
	if is_on_floor() or is_on_ceiling():
		velocity_y = 0.0

func _process(delta: float) -> void:
	interactable_marker.visible = current_interactable_area != null and current_interactable_area.can_be_used()
	if interactable_marker.visible:
		interactable_marker.rotation_degrees += Vector3.UP * interaction_marker_rotation_speed * delta

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		velocity_y = jump_force
	if event.is_action_pressed("use") and current_interactable_area != null:
		current_interactable_area.trigger()

func _on_InteractableDetectionZone_area_entered(area: Area) -> void:
	current_interactable_area = area

func _on_InteractableDetectionZone_area_exited(_area: Area) -> void:
	current_interactable_area = null
