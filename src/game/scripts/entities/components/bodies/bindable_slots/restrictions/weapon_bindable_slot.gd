extends EquipmentBindableSlot
class_name WeaponBindableSlot

func _init():
	equipement_key = Equipment.EquipmentCategory.WEAPON
	update_key()
	super._init()

func update_key():
	slot_key = Weapon.get_key() 
