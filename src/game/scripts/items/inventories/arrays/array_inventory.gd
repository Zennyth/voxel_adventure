class_name ArrayInventory
extends Inventory

@export var slots := []

func _init(slot_number: int):
	for i in range(slot_number):
		slots.append(Slot.new(i))

func get_slot(index: int) -> Slot:
	return slots[index]

func set_slot(index: int, slot: Slot):
    slots[index] = slot

func get_slot_number() -> int:
	return len(slots)

func get_indexes() -> List:
    return range(get_slot_number())