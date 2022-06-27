extends SlotContainer

@export var identifier: Cosmetic.CosmeticCategory:
	set(_identifier):
		identifier = _identifier
		id = identifier

func _init():
	id = identifier


func is_accepting_item(item: Item) -> bool:
	return item is Cosmetic and identifier == item.cosmetic_category
