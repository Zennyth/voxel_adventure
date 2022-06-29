extends Item
class_name Equipment

enum EquipmentCategory {
	ARMOR,
	WEAPON,
    TRAVEL
}

@export var equipment_category: EquipmentCategory
@export var character_class: int
@export var stats: int
@export var secondary_mesh: Resource = null

func _init():
	item_category = Item.ItemCategory.EQUIPMENT
