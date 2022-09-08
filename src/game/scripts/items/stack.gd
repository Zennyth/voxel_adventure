extends Resource
class_name Stack

signal _stack_updated

@export var item: Resource:
	set(_item):
		item = _item
		_stack_updated.emit(self)

@export var quantity: int:
	set(_quantity):
		quantity = _quantity
		_stack_updated.emit(self)

func _init(item_reference = null, quantity_reference: int = -1):
	item = item_reference
	if quantity_reference != -1:
		quantity = quantity_reference

func fill_to(add_quantity: int) -> int:
	var original_quantity := quantity
	var potential_quantity := original_quantity + add_quantity
	
	if potential_quantity > item.max_stack_size:
		quantity = item.max_stack_size
		return item.max_stack_size - potential_quantity
	
	quantity = potential_quantity
	return 0



###
# UTILS
# Item
###
func is_empty() -> bool:
	return item == null or quantity == 0

func get_item() -> Item:
	return item

func get_item_name() -> String:
	if item == null:
		return ""
	
	return item.name

func is_item_stackable() -> bool:
	return item != null and item.is_stackable

func is_item_collectable() -> bool:
	return item != null and item.is_collectable

func get_item_max_stack_size() -> int:
	return item.max_stack_size if item != null else 0 

func get_item_mesh() -> Mesh:
	return item.get_mesh if item != null else null

func get_item_category() -> Item.ItemCategory:
	return item.item_category if item != null else null