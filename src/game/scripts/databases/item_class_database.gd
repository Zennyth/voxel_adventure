extends ResourceDatabase

var _item_classes: Dictionary = {}

func init():
	for file in FilesUtils.get_files_from_folder("res://scripts/items/items/"):
		var item_class = load(file)
		_item_classes[item_class.get_item_class()] = file


func get_by_name(name_item_class: String):
	if not name_item_class in _item_classes:
		return null
	
	return load(_item_classes[name_item_class]).new()


func get_all() -> Array:
	return _item_classes.values()
