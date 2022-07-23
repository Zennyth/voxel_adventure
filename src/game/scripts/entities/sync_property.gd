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


func _init(property, key_: String, owner_: Stateful, parse_function_ = null, dump_function_ = null, is_stable_: bool = true):
	_property = property
	key = key_
	owner = owner_
	is_stable = is_stable_
	
	if parse_function_:
		parse_function = parse_function_
	
	if dump_function_:
		dump_function = dump_function_

	if owner:
		owner.register_property(self)


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
