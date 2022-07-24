extends RefCounted
class_name SyncProperty

signal _property_changed(property)
signal _sync_property_changed(sync_property: SyncProperty)

var _property
var key: String
var owner: Stateful
var is_stable: bool
var parse_function: Callable
var dump_function: Callable


func _init(property, key_: String, owner_: Stateful, is_stable_: bool = true, options: Dictionary = {}):
	_property = property
	key = key_
	owner = owner_
	is_stable = is_stable_
	
	set_option("parse", "parse_function", options)
	set_option("dump", "dump_function", options)


func get_property():
	return _property

func set_property(new_property):
	_property = new_property
	
	_property_changed.emit(_property)
	_sync_property_changed.emit(self)


func dump():
	return dump_function.call(_property) if dump_function else _property

func parse(data):
	set_property(parse_function.call(data) if parse_function else data)


###
# Utils
###
func set_option(option_name: String, property_name: String, options: Dictionary):
	if option_name in options:
		set(property_name, options[option_name])
