extends SaveManager
class_name CharacterSaveManager

var character_path := ""

func load_character_path(character_id: int):
    character_path = ROOT_PATH + "characters/" + str(character_id)

enum CHARACTER_SAVE_CATEGORY {
    INVENTORY,
}

