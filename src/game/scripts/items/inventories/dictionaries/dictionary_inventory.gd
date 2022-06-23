class_name DictionaryInventory
extends Inventory

var slots := {}

func get_slot(index) -> Slot:
	return slots[index]

func set_slot(index, slot: Slot):
	slots[index] = slot
