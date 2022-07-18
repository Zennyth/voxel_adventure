extends SlotContainer

@export var identifier: Travel.TravelCategory:
	set(_identifier):
		identifier = _identifier
		update_id()

func _init():
	update_id()

func update_id():
	key = Travel.get_key(identifier)


func is_accepting_item_reference(item: ItemReference) -> bool:
	return item is Travel and identifier == item.travel_category
