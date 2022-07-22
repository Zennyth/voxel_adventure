extends Reference
class_name SyncProperty

signal _property_changed(property)

var _property
var key: String
var owner: Entity
var is_stable: bool
var parse: Callable


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
    set_property(parse(data) if parse else data)