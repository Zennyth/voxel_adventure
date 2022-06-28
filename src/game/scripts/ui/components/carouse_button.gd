@tool

extends HBoxContainer
class_name CarouselButton

@onready var LabelNode: Label = $PanelControl/Label

@export var label: String = "":
	set(_label):
		label = _label
		update_label_text()

func _ready():
	update_label_text()

func update_label_text():
	LabelNode.text = label
