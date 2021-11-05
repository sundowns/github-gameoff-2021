extends Control
class_name SpeechBubbleContainer

# Referenced / Extended https://github.com/Harrison-Miller/SpeechBubble/blob/master/SpeechBubble.gd

onready var text_box: RichTextLabel = $NinePatchRect/MarginContainer/RichTextLabel
onready var text_bg = $NinePatchRect/ColorRect
onready var timer: Timer = $Timer
onready var tween: Tween = $Tween

var is_writing_out_text := false
var is_waiting_for_prompt := false

signal text_finished_displaying
signal speech_bubble_closing
signal prompt_pressed

const margin_offset = 8
const delay_beforehand := 0.2
const delay_afterward := 2.0
const time_per_char = 0.02

func display_text(new_text: String):
	timer.stop()
# warning-ignore:return_value_discarded
	tween.stop_all()
	visible = true
	
	text_box.percent_visible = 0
	is_writing_out_text = true
	yield(get_tree().create_timer(delay_beforehand), "timeout")
	
	text_box.bbcode_text = new_text
	
	# Duration
	var duration = text_box.text.length() * time_per_char
	
	# Set the size of the speech bubble
	var text_size = text_box.get_font("normal_font").get_string_size(text_box.text)
	text_box.margin_right = text_size.x + margin_offset
	
# warning-ignore:return_value_discarded
	tween.remove_all()
# warning-ignore:return_value_discarded
	tween.interpolate_property(text_box, "percent_visible", 0, 1, duration)
#	tween.interpolate_property(text_bg, "margin_right", 0, text_size.x + margin_offset, duration)
#	tween.interpolate_property($NinePatchRect, "position", Vector2.ZERO, Vector2(-text_size.x/2, 0), duration)
# warning-ignore:return_value_discarded
	tween.start()

func _on_display_text_ended():
	is_writing_out_text = false

func _on_prompt_press():
	is_waiting_for_prompt = false
	emit_signal("prompt_pressed")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and is_waiting_for_prompt:
		_on_prompt_press()

func _on_Tween_tween_all_completed() -> void:
	timer.start(delay_afterward)
	emit_signal("text_finished_displaying")

func _on_Timer_timeout() -> void:
	emit_signal("speech_bubble_closing")
	visible = false
