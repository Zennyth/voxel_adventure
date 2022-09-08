extends CanvasLayer

###
# OnScreen
###
signal _debug_property_updated(key, value)

var debug_properties: Dictionary = {}

func update_debug_property(key, value):
  debug_properties[key] = value
  _debug_property_updated.emit(key, value)


###
# InGame
###
const DebugVector3 = preload("../debug/debug_vector.gd")

var draw: DebugVector3 = DebugVector3.new()

func _ready():
  add_child(draw)