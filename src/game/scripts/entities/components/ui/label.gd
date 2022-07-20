extends Component
class_name LabelComponent

var label: Label3D
var text: SyncProp

func _init():
	label = $"." as Label3D
    text = SyncProp.new(label.text, WorldState.STATE_KEYS.LABEL, self)


func set_text(new_text: String):
	if not label:
		return
	
	text.set_property(new_text)