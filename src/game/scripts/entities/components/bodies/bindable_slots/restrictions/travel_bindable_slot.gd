extends BindableSlot
class_name TravelBindableSlot

@export var travel_key: Travel.TravelCategory:
	set(_travel_key):
		travel_key = _travel_key
		slot_key = travel_key

func _init():
	super._init()
	slot_key = travel_key
	item_category = Item.ItemCategory.EQUIPMENT
