extends BindableSlot
class_name EquipmentBindableSlot

var equipement_key: Equipment.EquipmentCategory

func _init():
	item_category = ItemReference.Category.EQUIPMENT
	super._init()
