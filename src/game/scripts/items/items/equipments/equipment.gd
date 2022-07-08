extends Item
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
	item_category = Item.ItemCategory.EQUIPMENT


static func get_key(_identifier = null) -> String:
	return Item.get_key() + str(Item.ItemCategory.EQUIPMENT)
