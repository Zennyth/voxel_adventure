extends Control
class_name SequenceMenu

@onready var Previous: Button = $Previous

func _on_previous_step_changed(step: String):
	if Previous == null:
		return
	Previous.visible = step != ""

func _on_previous_pressed():
	previous_step()


var is_previous: bool:
	get:
		return Launch.is_previous_step
	set(value):
		Launch.is_previous_step = value

var skip: bool:
	get:
		return skip_condition()


func _init():
	if !is_previous and skip:
		next_step(logical_next_step())

func _ready():
	Launch._previous_step_changed.connect(_on_previous_step_changed)
	_on_previous_step_changed(Launch.previous_step)

func _exit_tree():
	Launch._previous_step_changed.disconnect(_on_previous_step_changed)


func next_step(scene):
	is_previous = false
	Launch.set_previous_step(self)
	get_tree().change_scene_to_packed(scene)

func previous_step():
	if Launch.previous_step == "":
		return
	
	is_previous = true
	get_tree().change_scene_to_file(Launch.previous_step)
	Launch.set_previous_step(self)

func logical_next_step() -> PackedScene:
	return null

func skip_condition() -> bool:
	return false
