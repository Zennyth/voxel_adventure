extends EquipmentBindableSlot
class_name WeaponBindableSlot


@export var weapon_key: Weapon.SlotCategory = Weapon.SlotCategory.LEFT_HAND:
	set(_weapon_key):
		weapon_key = _weapon_key
		update_key()

func _init():
	equipement_key = Equipment.EquipmentCategory.WEAPON
	update_key()
	super._init()

func update_key():
	slot_key = Weapon.get_key(weapon_key) 
