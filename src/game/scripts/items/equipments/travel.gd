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

static func get_key(category_reference = null) -> String:
	return Equipment.get_key() + "_" + str(Equipment.EquipmentCategory.TRAVEL) + "_" + str(category_reference)

static func get_item_class() -> String:
	return "Travel"

func get_class() -> String:
	return "Travel" 