extends Resource
class_name Stack

signal stack_updated

var item: Item:
	set(_item):
		item = _item
		stack_updated.emit(self)

var quantity: int:
	set(_quantity):
		quantity = _quantity
		stack_updated.emit(self)

func _init(item_reference, quantity_reference: int = 0):
	
	item = item_reference if item_reference is Item else ItemDatabase.get_item(item_reference)
	quantity = quantity_reference

func fill_to(remaining_quantity: int) -> int:
	var original_quantity := quantity
	quantity = min(original_quantity + remaining_quantity, item.max_stack_size)
	return remaining_quantity - quantity - original_quantity

func is_empty() -> bool:
	return item == null or quantity == 0

func get_item_name() -> String:
	if item == null:
		return ""
	
	return item.name

func is_item_stackable() -> bool:
	return item != null and item.is_stackable
