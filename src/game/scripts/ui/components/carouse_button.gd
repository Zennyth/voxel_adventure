@tool

extends HBoxContainer
class_name CarouselButton

var list: Array = []:
	set(_list):
		list = _list

		if len(list) < 2:
			disable_buttons()
			return
		
		enable_buttons()

signal _index_changed(new_index: int)

var index: int = -1:
	set(_index):
		if len(list) < index or _index == index:
			return
		
		index = _index
		_index_changed.emit(index)

func step_index(step: int):
	index = (index + step) % len(list)


@onready var LabelNode: Label = $PanelControl/Label

@export var label: String = "":
	set(_label):
		label = _label
		update_label_text()

func update_label_text():
	if LabelNode: LabelNode.text = label


signal _previous
signal _next

@onready var PreviousButton: TextureButton = $PreviousButton
@onready var NextButton: TextureButton = $NextButton

func _on_previous_button_pressed():
	_previous.emit()
	step_index(-1)
	
func _on_next_button_pressed():
	_next.emit()
	step_index(1)


func disable_buttons():
	if not PreviousButton or not NextButton:
		return
	
	PreviousButton.disabled = true
	NextButton.disabled = true

func enable_buttons():
	if not PreviousButton or not NextButton:
		return
	
	PreviousButton.disabled = false
	NextButton.disabled = false

func _ready():
	update_label_text()
	PreviousButton.connect("pressed", _on_previous_button_pressed)
	NextButton.connect("pressed", _on_next_button_pressed)
