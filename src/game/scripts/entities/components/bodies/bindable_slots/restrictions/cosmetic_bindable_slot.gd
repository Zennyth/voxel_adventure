extends BindableSlot
class_name CosmeticBindableSlot

@export var cosmetic_key: Cosmetic.CosmeticCategory:
	set(_cosmetic_key):
		cosmetic_key = _cosmetic_key
		slot_key = cosmetic_key

func _init():
	super._init()
	slot_key = cosmetic_key
	item_category = Item.ItemCategory.COSMETIC
