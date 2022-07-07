extends EquipmentBindableSlot
class_name WeaponBindableSlot

@export var weapon_key: Armor.ArmorCategory:
	set(_weapon_key):
		weapon_key = _weapon_key
		update_key()

func _init():
	equipement_key = Equipment.EquipmentCategory.WEAPON
	update_key()
	super._init()

func update_key():
	update_slot_key(str(weapon_key))
