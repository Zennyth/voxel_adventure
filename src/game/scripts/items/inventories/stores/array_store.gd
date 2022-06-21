extends InventoryStore
class_name ArrayInventoryStore

var _array: Array = []

func get_index(index: int) -> StackResource:
	if _array.size() < index:
		return null

	return _array[index]

func append(stack: StackResource, index = -1):
	if index == -1:
		_array.append(stack)
	else:
		_array[index] = stack

func list() -> Array:
	return _array
