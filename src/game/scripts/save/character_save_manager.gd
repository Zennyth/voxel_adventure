extends SaveManager
class_name CharacterSaveManager

func _init():
	folder_path = ROOT_PATH + "characters/"
	set_save_path(generate_identifier())

func save_character(character_data: DataManager):
	print(full_path + "character.tres")
	ResourceSaver.save(full_path + "character.tres", character_data)

func load_character() -> DataManager:
	if ResourceLoader.exists(full_path + "character.tres"):
		var character_data = ResourceLoader.load(full_path + "character.tres")
		return character_data as DataManager
	
	return null
