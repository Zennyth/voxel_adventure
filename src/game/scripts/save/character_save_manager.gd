extends SaveManager
class_name CharacterSaveManager

func _init():
	folder_path = ROOT_PATH + "characters/"
	set_save_path(generate_identifier())

func save_character(character_data: DataManager):
	ResourceSaver.save(character_data, full_path + "character.tres")

func load_character(character_identifier = null) -> DataManager:
	var use_path: String = folder_path + character_identifier + "/" if character_identifier else full_path

	if ResourceLoader.exists(use_path + "character.tres"):
		var character_data = ResourceLoader.load(full_path + "character.tres")
		return character_data as DataManager
	
	return null

func get_character_identidiers() -> Array:
	return FilesUtils.get_folders(folder_path)

func get_characters() -> Array:
	var characters := []

	for character_identidier in get_character_identidiers():
		var character: DataManager = load_character(character_identidier) 
		
		if not character:
			continue
		
		characters.append(character)
	
	return characters
