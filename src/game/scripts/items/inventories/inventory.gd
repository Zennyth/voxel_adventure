extends Resource
class_name Inventory

# enum Inventories {
# 	COSMETIC,
# 	EQUIPMENT,
# 	ITEM
# }

# signal inventory_changed
# signal slot_changed(slot)
# signal stack_changed(stack)

# var _stacks: InventoryStore:
# 	set(stacks):
# 		_stacks = stacks
# 		inventory_changed.emit(_stacks)

# func _init(store: InventoryStore = ArrayInventoryStore.new()):
# 	_stacks = store

# func get_item(index) -> ItemResource:
# 	return get_stack_item(index).item

# func get_stack_item(index) -> StackResource:
# 	return _stacks.get(index)

# func set_stack(key, stack: StackResource):
# 	_stacks.append(stack, key)


# func add_item(item_reference, quantity: int = 1):
# 	if quantity <= 0:
# 		return
	
# 	var item: ItemResource = item_reference if item_reference is ItemResource else ItemDatabase.get_item(item_reference) 
# 	if not item:
# 		return
	
# 	var remaining_quantity = quantity
	
# 	if item.is_stackable:
# 		for stack in _stacks.list():
# 			if remaining_quantity == 0:
# 				break
			
# 			if stack.item.name != item.name:
# 				continue
			
# 			if stack.quantity < item.max_stack_size:
# 				remaining_quantity = stack.fill_to(remaining_quantity)
	
# 	while remaining_quantity > 0:
# 		var stack := StackResource.new(item)
# 		remaining_quantity = stack.fill_to(remaining_quantity)
# 		_stacks.append(stack)
# 		inventory_changed.emit(_stacks)
