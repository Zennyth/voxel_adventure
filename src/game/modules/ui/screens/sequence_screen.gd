extends Control
class_name SequenceMenu

var is_previous: bool:
	get():
		return Launch.is_previous_step
	set(value):
		Launch.is_previous_step = value

func next_step(scene):
	is_previous = false
	get_tree().change_scene(scene)

func previous_step(scene):
	is_previous = true
	get_tree().change_scene(scene)