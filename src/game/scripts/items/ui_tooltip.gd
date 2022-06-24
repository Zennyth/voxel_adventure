extends ColorRect
class_name Tooltip

onready var margin_container = $MarginContainer
onready var label = $MarginContainer/Label

func _process(delta):
	set_position(get_global_mouse_position() + Vector2.ONE * 4)

func display_info(tooltip):
	label.text = tooltip
	yield(get_tree(), "idle_frame")
	margin_container.rect_size = Vector2()
	rect_size = margin_container.rect_size