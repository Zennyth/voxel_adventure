class_name DictionaryInventory
extends Inventory

@export var slots := {}

func _init(inventory_keys: Array = []):
	for key in inventory_keys:
		set_slot(key, Slot.new(key))

func get_slot(index) -> Slot:
	return slots[index] if index in slots else null

func set_slot(index, slot: Slot):
	slots[index] = slot

func get_slot_number() -> int:
	return len(slots)

func get_slots() -> Array:
	return slots.values()

func get_indexes() -> Array:
	return slots.keys()
