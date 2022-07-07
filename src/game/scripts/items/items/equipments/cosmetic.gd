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
