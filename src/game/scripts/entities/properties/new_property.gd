extends Property
class_name NewProperty

var _value

func _init(value, key_, owner_: Stateful, is_stable_: bool = true, options: Dictionary = {}):
	super._init(key_, owner_, is_stable_, options)

	set_value(value)


func get_value():
	return _value

func set_value(new_value):
	if get_value() == new_value:
		return

	_value = new_value
	super.set_value(new_value)
