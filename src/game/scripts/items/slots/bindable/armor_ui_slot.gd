extends SlotContainer

@export var identifier: Armor.ArmorCategory:
	set(_identifier):
		identifier = _identifier
		id = identifier

func _init():
	id = identifier


func is_accepting_item(item: Item) -> bool:
    return item is Armor and identifier == item.armor_category