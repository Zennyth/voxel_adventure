extends BindableSlot
class_name ArmorBindableSlot

@export var armor_key: Armor.ArmorCategory:
	set(_armor_key):
		armor_key = _armor_key
		slot_key = armor_key

func _init():
	super._init()
	slot_key = armor_key
	item_category = Item.ItemCategory.EQUIPMENT
