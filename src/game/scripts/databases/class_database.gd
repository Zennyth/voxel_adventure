extends ResourceDatabase

var _character_classes: Dictionary = {}

func init():
	for file in FilesUtils.get_files_from_folder(PATH + "classes/"):
		var character_class: Class = load(file)
		_character_classes[character_class.name] = character_class


func get_by_name(character_class_name: String) -> Race:
	if not character_class_name in _character_classes:
		return null
	
	return _character_classes[character_class_name]


func get_all() -> Array:
	return _character_classes.values()
