extends Spatial
class_name Item

export(String) var key: String = ""
export(PackedScene) var dropped_item_scene: PackedScene

func use():
	pass

func drop():
	var old_position = get_parent().global_transform.origin
	var new_position = Vector3(old_position.x, 0, old_position.z)
	NarrativeState.item_dropped(key, new_position)
	var dropped_item = dropped_item_scene.instance()
	var entities_node = get_tree().current_scene.get_node(Global.overworld_node_scenepath + "/Entities" )
	entities_node.add_child(dropped_item)
	dropped_item.global_transform.origin = new_position
	
	print('i drop dis')
	call_deferred("queue_free")

