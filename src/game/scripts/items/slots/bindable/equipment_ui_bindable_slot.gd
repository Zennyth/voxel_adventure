extends SlotContainer

@export var identifier: EquipmentBindableSlot.EquipmentBindableSlotKey = EquipmentBindableSlot.EquipmentBindableSlotKey.CHEST_PLATE:
	set(_identifier):
		identifier = _identifier
		id = identifier

func _init():
	id = identifier
