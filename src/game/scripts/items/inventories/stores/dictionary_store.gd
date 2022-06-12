extends InventoryStore
class_name DictionaryInventoryStore

var _dict: Dictionary = {}

func get_index(index) -> Stack:
	if not index in _dict:
        return null 

	return _dict[index]

func append(stack: Stack, index = -1):
	_dict[index] = stack

func list() -> Array:
	return _dict.values()