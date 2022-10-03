extends Property
class_name BindedProperty

var _path_value: String

func _init(path_value: String, key_, owner_: Stateful, is_stable_: bool = true, options: Dictionary = {}):
	super._init(key_, owner_, is_stable_, options)

	_path_value = path_value
	
	set_value(get_value())


func get_value():
	return NodeUtils.recursive_get(owner, _path_value)

func set_value(new_value):
	if get_value() == new_value:
		return

	NodeUtils.recursive_set(owner, _path_value, new_value)
	super.set_value(new_value)
