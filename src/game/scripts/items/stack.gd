extends Object
class_name Stack

var item: ItemResource
var quantity: int

func _init(item_reference, quantity_reference: int = 0):
	item = item_reference if item_reference is ItemResource else ItemDatabase.get_item(item_reference)
	
	quantity = quantity_reference

func fill_to(remaining_quantity: int) -> int:
	var original_quantity := quantity
	quantity = min(original_quantity + remaining_quantity, item.max_stack_size)
	return remaining_quantity - quantity - original_quantity
