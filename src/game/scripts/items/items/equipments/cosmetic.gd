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

static func get_key(category_reference: CosmeticCategory) -> String:
    return super.get_key() + "_" + str(Equipment.EquipmentCategory.COSMETIC) + "_" + str(category_reference)