extends SlotContainer

@export var identifier: Armor.ArmorCategory:
	set(_identifier):
		identifier = _identifier
		update_id()

func _init():
	update_id()

func update_id():
	key = Armor.get_key(identifier)

func is_accepting_item(item: Item) -> bool:
	return item is Armor and identifier == item.armor_category
