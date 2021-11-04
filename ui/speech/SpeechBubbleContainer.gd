extends Control

onready var text_box: RichTextLabel = $NinePatchRect/RichTextLabel
onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_writing_out_text := false

func display_text(new_text: String):
	text_box.percent_visible = 0
	text_box.text = new_text
	is_writing_out_text = true
	animation_player.play("DisplayText")

func _on_display_text_ended():
	is_writing_out_text = false
