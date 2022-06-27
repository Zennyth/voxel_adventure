extends Equipment
class_name Weapon

func _init():
	equipment_category = Equipment.EquipmentCategory.WEAPON


enum WieldCategory {
	SINGLE_HANDED,
	TWO_HANDED
}

@export var wield_category: WieldCategory = WieldCategory.SINGLE_HANDED
