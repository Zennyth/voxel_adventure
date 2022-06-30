extends ResourceDatabase

var _items: Dictionary = {}

func init():
	for file in FilesUtils.get_files_from_folder(PATH + "items/"):
		var item: Item = load(file)
		_items[item.name] = item


func get_by_name(item_name: String) -> Item:
	if not item_name in _items:
		return null
	
	return _items[item_name]


func get_all() -> Array:
	return _items.values()
