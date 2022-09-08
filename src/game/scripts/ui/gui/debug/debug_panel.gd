extends Control
class_name DebugPanel

var debug_properties := {}

func _ready():
	for debug_property in NodeUtils.findNodeDescendantsInGroup(self, "debug_property"):
		register_property(debug_property as DebugProperty)
	
	Debug._debug_property_updated.connect(_on_debug_property_updated)

	for debug_property_key in Debug.debug_properties:
		_on_debug_property_updated(debug_property_key, Debug.debug_properties[debug_property_key])
	

func register_property(property: DebugProperty):
	var key = property.key

	if key not in debug_properties:
		debug_properties[key] = []
	
	debug_properties[key].append(property)

func _on_debug_property_updated(key, value):
	if key not in debug_properties:
		return
	
	for debug_property in debug_properties[key]:
		debug_property.update_value(value)
