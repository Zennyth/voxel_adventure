extends BindableSlot
class_name EquipmentBindableSlot

enum EquipmentBindableSlotKey {
	CHEST_PLATE,
	AMULET,

	FACE,
	EYES,
	HELMET,

	SHOES,

	GLOVES,

	LEFT_HAND_WEAPON,
	RIGHT_HAND_WEAPON
}

@export var equipement_key: EquipmentBindableSlotKey = EquipmentBindableSlotKey.CHEST_PLATE:
	set(_equipement_key):
		equipement_key = _equipement_key
		slot_key = equipement_key

func _init():
	super._init()
	slot_key = equipement_key
