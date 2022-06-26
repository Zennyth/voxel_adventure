extends Resource
class_name Stack

signal stack_updated

@export var item: Resource:
	set(_item):
		item = _item
		stack_updated.emit(self)

@export var quantity: int:
	set(_quantity):
		quantity = _quantity
		stack_updated.emit(self)

func _init(item_reference = "", quantity_reference: int = -1):
	
	item = item_reference if item_reference is Item else ItemDatabase.get_item(item_reference)
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

func is_empty() -> bool:
	return item == null or quantity == 0

func get_item_name() -> String:
	if item == null:
		return ""
	
	return item.name

func is_item_stackable() -> bool:
	return item != null and item.is_stackable
