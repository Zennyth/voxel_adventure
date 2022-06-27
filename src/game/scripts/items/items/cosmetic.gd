extends Item
class_name Cosmetic

enum CosmeticCategory {
	HAIR,
	FACE,
	EYES,
	CHEST,
	HANDS,
	FEET
}

@export var cosmetic_category: CosmeticCategory
@export var secondary_mesh: Resource

func _init():
	item_category = Item.ItemCategory.COSMETIC
