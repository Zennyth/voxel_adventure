extends SlotContainer

@export var identifier: Travel.TravelCategory:
	set(_identifier):
		identifier = _identifier
		id = identifier

func _init():
	id = identifier


func is_accepting_item(item: Item) -> bool:
	return item is Travel and identifier == item.travel_category
