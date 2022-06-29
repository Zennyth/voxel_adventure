extends Database

var _items: Dictionary = {}

func init():
	for file in FilesUtils.get_files_from_folder("res://resources/items/"):
		var item: Item = load(file)
		_items[item.name] = item


func get(item_name: String) -> Item:
	if not item_name in _items:
		return null
	
	return _items[item_name]


func get_all() -> Array:
    return _races.values()