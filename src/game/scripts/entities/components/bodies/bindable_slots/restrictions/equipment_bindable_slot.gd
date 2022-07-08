extends BindableSlot
class_name EquipmentBindableSlot

var equipement_key: Equipment.EquipmentCategory

func _init():
	item_category = Item.ItemCategory.EQUIPMENT
	super._init()
