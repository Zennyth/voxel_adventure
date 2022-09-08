extends Node

signal _debug_property_updated(key, value)

var debug_properties: Dictionary = {}

func update_debug_property(key, value):
  debug_properties[key] = value
  _debug_property_updated.emit(key, value)