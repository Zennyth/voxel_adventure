extends EquipmentBindableSlot
class_name CosmeticBindableSlot

@export var cosmetic_key: Cosmetic.CosmeticCategory:
	set(_cosmetic_key):
		cosmetic_key = _cosmetic_key
		update_key()

func _init():
	# visible(false)
	equipement_key = Equipment.EquipmentCategory.COSMETIC
	update_key()
	super._init()

func update_key():
	update_slot_key(str(cosmetic_key))
