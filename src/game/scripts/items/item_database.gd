extends Node

var _items: Dictionary = {}

func _ready():
	for file in FilesUtils.get_files_from_folder("res://resources/items/"):
		var item: Item = load(file)
		_items[item.name] = item

func get_item(item_name: String):
	return _items[item_name] 
