extends StackContainer
class_name DragPreview

func _process(_delta):
	if stack:
		set_position(get_global_mouse_position())
