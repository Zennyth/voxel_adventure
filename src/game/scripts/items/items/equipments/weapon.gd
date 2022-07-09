extends Equipment
class_name Weapon

func _init():
	equipment_category = Equipment.EquipmentCategory.WEAPON


enum WieldCategory {
	SINGLE_HANDED,
	TWO_HANDED
}
@export var wield_category: WieldCategory = WieldCategory.SINGLE_HANDED


enum SlotCategory {
	LEFT_HAND,
	RIGHT_HAND
}
static func get_key(identifier = null) -> String:
	return Equipment.get_key() + "_" + str(Equipment.EquipmentCategory.WEAPON) + "_" + str(identifier)
