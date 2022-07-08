extends EquipmentBindableSlot
class_name TravelBindableSlot

@export var travel_key: Travel.TravelCategory:
	set(_travel_key):
		travel_key = _travel_key
		update_key()

func _init():
	equipement_key = Equipment.EquipmentCategory.TRAVEL
	update_key()
	super._init()

func update_key():
	slot_key = Travel.get_key(travel_key) 
