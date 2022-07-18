extends SlotContainer

@export var identifier: Weapon.SlotCategory:
	set(_identifier):
		identifier = _identifier
		update_id()

func _init():
	update_id()

func update_id():
	key = Weapon.get_key(identifier)

func is_accepting_item_reference(item: ItemReference) -> bool:
	return item is Weapon
