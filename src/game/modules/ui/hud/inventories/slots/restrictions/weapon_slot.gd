extends SlotContainer

@export var identifier: Weapon.SlotCategory:
	set(_identifier):
		identifier = _identifier
		update_id()

func _init():
	update_id()

func update_id():
	key = Weapon.get_key(identifier)

func is_accepting_item(item: Item) -> bool:
	return item is Weapon
