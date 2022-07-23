extends Equipment
class_name Cosmetic

func _init():
	equipment_category = Equipment.EquipmentCategory.COSMETIC

enum CosmeticCategory {
	HAIR,
	FACE,
	EYES,
	CHEST,
	HANDS,
	FEET
}

@export var cosmetic_category: CosmeticCategory

static func get_key(category_reference = null) -> String:
	return super.get_key() + "_" + str(Equipment.EquipmentCategory.COSMETIC) + "_" + str(category_reference)

static func get_item_class() -> String:
	return "Cosmetic"

func get_class() -> String:
	return "Cosmetic"
