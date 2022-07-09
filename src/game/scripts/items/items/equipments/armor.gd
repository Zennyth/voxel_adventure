extends Equipment
class_name Armor

func _init():
	equipment_category = Equipment.EquipmentCategory.ARMOR


enum ArmorCategory {
	HELMET,
	CHESTPLATE,
	GLOVES,
	SHOES,
	SHOULDER_PADS,
	RING,
	AMULET,
}

@export var armor_category: ArmorCategory

static func get_key(category_reference = null) -> String:
	return Equipment.get_key() + "_" + str(Equipment.EquipmentCategory.ARMOR) + "_" + str(category_reference)
