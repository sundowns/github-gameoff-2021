extends Spatial
class_name Item

export(String) var key: String = ""
export(PackedScene) var dropped_item_scene: PackedScene

func use():
	pass

func drop():
	NarrativeState.world_items_cache[key].is_player_holding = false
	var dropped_item = dropped_item_scene.instance()
	var old_position = get_parent().global_transform.origin
	replace_by(dropped_item)
	dropped_item.global_transform.origin = Vector3(old_position.x, 0, old_position.z)
	
	print('i drop dis')
	call_deferred("queue_free")

