extends PanelContainer

onready var item_list: ItemList = $Panel/MarginContainer/ItemList

func _on_ItemList_item_activated(index):
	print("menu item selected %d " % index)
	var selections = item_list.get_selected_items()
	for item in selections:
		print(item)


func _unhandled_input(event):
	
	if event.is_action_pressed("ui_cancel"):
#		Global.toggle_pause()
		print('pause')
