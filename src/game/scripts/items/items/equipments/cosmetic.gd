extends Equipment
class_name Cosmetic

func _init():
    item_category = Equipment.EquipmentCategory.COSMETIC

enum CosmeticCategory {
	HAIR,
	FACE,
	EYES,
	CHEST,
	HANDS,
	FEET
}

@export var cosmetic_category: CosmeticCategory