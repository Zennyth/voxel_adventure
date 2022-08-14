extends Component
class_name LabelComponent

var label: Label3D
var text := bind_property(label, "text", WorldState.STATE_KEYS.LABEL, true)

func _init():
	label = $"." as Label3D

func set_text(new_text: String):	
	text.sync_value(new_text)
