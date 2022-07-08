extends Equipment
class_name Travel

func _init():
	equipment_category = Equipment.EquipmentCategory.TRAVEL


enum TravelCategory {
	HANG_GLIDING,
	BOAT,
	PET
}

@export var travel_category: TravelCategory = TravelCategory.HANG_GLIDING

@export var speed: float = 0
@export var gravity: float = 0

static func get_key(category_reference: TravelCategory) -> String:
    return super.get_key() + "_" + str(Equipment.EquipmentCategory.TRAVEL) + "_" + str(category_reference)