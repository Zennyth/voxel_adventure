extends BindableSlot
class_name EquipmentBindableSlot

var equipement_key: Equipment.EquipmentCategory

func _init():
	item_category = Item.ItemCategory.EQUIPMENT
	super._init()

func update_slot_key(special_category: String):
	set_slot_key(str(equipement_key), special_category)
