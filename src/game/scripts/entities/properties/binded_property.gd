extends Property
class_name BindedProperty

var _owner_value: Object
var _key_value: String

func _init(owner_value: Object, key_value: String, key_: String, owner_: Stateful, is_stable_: bool = true, options: Dictionary = {}):
	super._init(key_, owner_, is_stable_, options)

	_owner_value = owner_value
	_key_value = key_value
	set_value(get_value())


func get_value():
	return NodeUtils.recursive_get(_owner_value, _key_value)

func set_value(new_value):
	if get_value() == new_value:
		return

	NodeUtils.recursive_set(_owner_value, _key_value, new_value)
	super.set_value(new_value)
