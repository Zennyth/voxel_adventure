class_name Item
extends Resource

###
# BUILT-IN
###
func _init(_item_reference: ItemReference = null, _modifiers: Dictionary = {}):
    item_reference = _item_reference
    modifiers = _modifiers


###
# BUILT-IN
# Item
###
@export var item_reference: Resource
func get_item_reference() -> ItemReference:
    return item_reference


###
# BUILT-IN
# Modifiers
###
@export var modifiers: Dictionary


###
# DECORATOR
# Item
###
func get_name() -> String:
	return item_reference.name

func is_collectable() -> bool:
    return item_reference.is_collectable()

func is_stackable() -> bool:
	return item_reference.is_stackable()

func get_max_stack_size() -> int:
    return item_reference.max_stack_size()

func get_mesh() -> Mesh:
    return item_reference.mesh

func get_category() -> ItemReference.Category:
    return item_reference.category
