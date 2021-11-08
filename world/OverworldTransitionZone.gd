extends Area

export(bool) var is_disabled := false setget set_disabled

export(String) var destination_scene
var packed_destination_scene: PackedScene = null

onready var debug_mesh_instance: MeshInstance = $DebugMeshInstance

func _ready():
	debug_mesh_instance.visible = Global.is_debug
	if destination_scene == null or destination_scene == "":
		push_error("OverworldTransitionZone is missing a scene to transition to.")
	else:
		packed_destination_scene = load(destination_scene)

func set_disabled(_is_disabled):
	is_disabled = _is_disabled
	monitoring = not is_disabled

func triggered():
	if packed_destination_scene != null:
		Global.request_level_change(packed_destination_scene)

func _on_OverworldTransitionZone_body_entered(body: Node) -> void:
	if is_disabled:
		return
	if body.is_in_group("Player"):
		triggered()
