extends Component
class_name LabelComponent

var label: Label3D
var text_value := bind_property("text", WorldState.STATE_KEYS.LABEL)

func _init():
	label = $"." as Label3D

func set_text(new_text: String):
	text_value.sync_value(new_text)
