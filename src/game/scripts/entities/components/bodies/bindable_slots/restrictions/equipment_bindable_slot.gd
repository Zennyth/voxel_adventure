extends BindableSlot
class_name EquipmentBindableSlot

var equipement_key: Equipment.EquipmentCategory

func update_slot_key(special_category: String):
    set_slot_key(str(equipement_key), special_category)
