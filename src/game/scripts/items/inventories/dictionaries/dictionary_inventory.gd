class_name DictionaryInventory
extends Inventory

@export var slots := {}

func _init(slot_keys: List):
	for key in slot_keys:
		set_slot(key, Slot.new(i))

func get_slot(index) -> Slot:
	return slots[index]

func set_slot(index, slot: Slot):
	slots[index] = slot

func get_slot_number() -> int:
    return len(slots)

func get_indexes() -> List:
    return slots.keys()