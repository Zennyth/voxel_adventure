extends Control
class_name DebugPanel

var debug_properties := {}

func _ready():
    for debug_property in get_nodes_in_group("debug_property"):
        register_property(debug_property as DebugProperty)
    
    EventBus._debug_property_updated.connect(_on_debug_property_updated)

func register_property(property: DebugProperty):
    var key = property.key

    if key not in debug_properties:
        debug_properties[key] = []
    
    debug_properties[key].append(property)

func _on_debug_property_updated(key: String, value):
    if key not in debug_properties:
        return
    
    for debug_property in debug_properties[key]:
        debug_property.update_value(value)
