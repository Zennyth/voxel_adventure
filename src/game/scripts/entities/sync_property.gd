extends Reference
class_name SyncProperty

var _property
var key: String
var owner: Entity
var is_stable: bool
var parse: Callable

signal _property_changed(property)

func _init(property, key_: String, owner_: Stateful, parse_: Callable = null, is_stable_: bool = true):
    _property = property
    key = key_
    owner = owner_
    is_stable = is_stable_
    parse = parse_

    if owner:
        owner.register_property(self)


func get_property():
    return _property

func set_property(new_property):
    _property = new_property

    update_state()


func dump():
    if _property.has_method('dump'):
        return _property.dump()

    return _property

func parse(data):
    if parse:
        set_property(parse(data))
        return

    set_property(data)