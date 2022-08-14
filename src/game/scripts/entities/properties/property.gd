extends RefCounted
class_name Property

signal _value_changed(value)
signal _property_value_changed(property: Property)

var key: String:
	set(value):
		key = value
		if key != null and not _has_been_registered:
			register(self)

var owner: Stateful:
	set(value):
		owner = value
		# TODO: check if ready
		owner.ready.connect(register)

var is_stable: bool
var ignore_duplicates := true
var parse_function: Callable
var dump_function: Callable

var _has_been_registered := false


func _init(key_: String, owner_: Stateful, is_stable_: bool = true, options: Dictionary = {}):
	key = key_
	owner = owner_
	is_stable = is_stable_
	
	set_option("parse", "parse_function", options)
	set_option("dump", "dump_function", options)
	set_option("ignore_duplicates", "ignore_duplicates", options)
	if "on_changed" in options:
		_property_changed.connect(options["on_changed"])


func register(_owner: Stateful):
	if key == null:
		return
	
	owner.register_property(self)
	_has_been_registered = true


func get_value():
	pass

func set_value(new_value):
	_value_changed.emit(new_value)

func sync_value(new_value):
	if not owner or owner_.is_authoritative():
		return
	
	set_value(new_value)
	_property_value_changed.emit(self)


func dump():
	return dump_function.call(_property) if dump_function else _property

func parse(data):
	set_value(parse_function.call(data) if parse_function else data)


###
# Utils
###
func set_option(option_name: String, property_name: String, options: Dictionary):
	if option_name in options:
		set(property_name, options[option_name])
