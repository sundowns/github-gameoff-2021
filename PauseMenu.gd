extends PanelContainer

onready var item_list: ItemList = $Panel/MarginContainer/ItemList

var disabled := false

var current_selection = 0

func _ready():
	disabled = true
	call_deferred("connect_signals")
	visible = Global.is_paused

func connect_signals():
	Global.register_subscriber(self, "_on_pause_changed")

func _on_ItemList_item_activated(index):
	activate_menu_option(item_list.get_item_text(index))

func activate_menu_option(option: String):
	match option:
		"Resume":
			Global.toggle_pause()
		"Quit":
			get_tree().quit()

func _process(_delta: float) -> void:
	if Global.is_paused:
		item_list.select(current_selection)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		Global.toggle_pause()
	if Global.is_paused:
		if event.is_action_pressed("ui_up"):
			change_selection_to(current_selection - 1)
		elif event.is_action_pressed("ui_down"):
			change_selection_to(current_selection + 1)
		elif event.is_action("ui_accept"):
			activate_menu_option(item_list.get_item_text(current_selection))

func _on_pause_changed(is_paused):
	disabled = is_paused
	visible = is_paused
	if is_paused:
		change_selection_to(0)

func change_selection_to(index: int):
	item_list.unselect_all()
	if index < 0:
		index = item_list.get_item_count() - 1
	if index >= item_list.get_item_count():
		index = 0
	current_selection = index
	item_list.select(current_selection)
