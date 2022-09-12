extends Control
class_name SequenceMenu


func _on_previous_pressed():
	previous_step()


var is_previous: bool:
	get():
		return Launch.is_previous_step
	set(value):
		Launch.is_previous_step = value

var skip: bool:
	get():
		return skip_condition()


func _init():
	if !is_previous and skip:
		next_step(play)


func next_step(scene):
	is_previous = false
	Launch.previous_scene = self
	get_tree().change_scene(scene)

func previous_step():
	if Launch.previous_scene == null:
		return
	
	is_previous = true
	Launch.previous_scene = self
	get_tree().change_scene(Launch.previous_scene)

func logical_next_step() -> PackedScene:
	return null

func skip_condition() -> bool:
	return false