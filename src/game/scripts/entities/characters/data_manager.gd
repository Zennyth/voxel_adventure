extends Resource
class_name DataManager

@export var character_name := ""

###
# LOGIC
# GAME
###
signal _character_race_update(new_race: Race)
@export var character_race: Resource:
	set(new_race):
		character_race = new_race
		_character_race_update.emit(character_race)

signal _character_class_update(new_class: Class)
@export var character_class: Resource:
	set(new_class):
		character_class = new_class
		_character_class_update.emit(new_class)

###
# BUILT-IN
# INVENTORIES
###
@export var inventories := {}

func has_inventory(inventory_key: Inventory.InventoryCategory) -> bool:
	return inventory_key in inventories

func get_inventory(inventory_key: Inventory.InventoryCategory) -> Inventory:
	if not has_inventory(inventory_key):
		return null
	
	return inventories[inventory_key]

func set_inventory(inventory_key: Inventory.InventoryCategory, inventory: Inventory):
	inventories[inventory_key] = inventory

func get_slot(inventory_key: Inventory.InventoryCategory, slot_key: int) -> Slot:
	var inventory := get_inventory(inventory_key)
	
	if not inventory:
		return null
	
	return inventory.get_slot(slot_key)

func set_new_stack(inventory_key: Inventory.InventoryCategory, slot_key: int, item: Item):
	var slot := get_slot(inventory_key, slot_key)
	
	if not slot:
		return
	
	slot.set_stack(Stack.new(item, item.max_stack_size))
