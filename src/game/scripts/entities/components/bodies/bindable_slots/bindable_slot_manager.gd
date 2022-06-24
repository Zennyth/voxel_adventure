extends Skeleton3D
class_name BindableSlotManager

var slot_keys := {}
var inventory: DictionaryInventory


func _ready():
	for bindable_slot in get_tree().get_nodes_in_group("bindable_slots"):
		if not bindable_slot.inventory_key in slot_keys:
			slot_keys[bindable_slot.inventory_key] = []

		slot_keys[bindable_slot.inventory_key].append(bindable_slot.slot_key)

func init_inventory(key: Inventory.InventoryKey, entity: Character):
	if key in entity.inventories:
		inventory = entity.inventories[key]
	else:
		inventory = DictionaryInventory.new(slot_keys[key])
		entity.inventories[key] = inventory

	for bindable_slot in get_tree().get_nodes_in_group("bindable_slots"):
		if not bindable_slot.inventory_key or bindable_slot.inventory_key != key:
			continue
		
		bindable_slot.slot = inventory.get_slot(bindable_slot.slot_key)
	
