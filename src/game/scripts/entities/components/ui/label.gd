extends Component
class_name LabelComponent

var label: Label3D
var text: SyncProperty

func _init():
	label = $"." as Label3D

func entity_ready():
	super.entity_ready()
	text = create_property(label.text, WorldState.STATE_KEYS.LABEL, true, {
		"on_changed": _on_text_updated
	})

func set_text(new_text: String):
	if not label or not text:
		return
	
	text.set_property(new_text)

func _on_text_updated(new_text):
	label.text = new_text
