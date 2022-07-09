extends SlotContainer

@export var identifier: Cosmetic.CosmeticCategory:
	set(_identifier):
		identifier = _identifier
		update_id()

func _init():
	update_id()

func update_id():
	key = Cosmetic.get_key(identifier)


func is_accepting_item(item: Item) -> bool:
	return item is Cosmetic and identifier == item.cosmetic_category
