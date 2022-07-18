extends ItemReference
class_name Equipment

enum EquipmentCategory {
	ARMOR,
	WEAPON,
	TRAVEL,
	COSMETIC
}

@export var equipment_category: EquipmentCategory
@export var character_class: int
@export var stats: int
@export var secondary_mesh: Resource = null

func _init():
	category = ItemReference.Category.EQUIPMENT


static func get_key(_identifier = null) -> String:
	return ItemReference.get_key() + str(ItemReference.Category.EQUIPMENT)
