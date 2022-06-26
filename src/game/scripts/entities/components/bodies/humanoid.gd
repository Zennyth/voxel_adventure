extends Body
class_name HumanoidBody

var humanoid: Humanoid
	
func _ready():
	super._ready()
	
	if not entity is Humanoid:
		print("Entity: ", entity, " is not a Humanoid !")
	
	if is_authoritative():
		init_cosmetic_inventory()
	# bindable_slot_manager.init_inventory(Inventory.InventoryKey.EQUIPMENT_INVENTORY, entity)

func init_cosmetic_inventory():
	var key := Inventory.InventoryKey.COSMETIC_INVENTORY
	entity.inventories[key] = DictionaryInventory.new(bindable_slot_manager.slot_keys[key])
	
	var equipment_inventory: Inventory = entity.inventories[key]
	
	equipment_inventory.get_slot(EquipmentBindableSlot.EquipmentBindableSlotKey.FACE).set_stack(Stack.new(ItemDatabase.get_item("Human Face 1"), 1))
	equipment_inventory.get_slot(EquipmentBindableSlot.EquipmentBindableSlotKey.CHEST_PLATE).set_stack(Stack.new(ItemDatabase.get_item("Basic Warrior Chest Plate"), 1))
	equipment_inventory.get_slot(EquipmentBindableSlot.EquipmentBindableSlotKey.GLOVES).set_stack(Stack.new(ItemDatabase.get_item("Basic Warrior Glove"), 1))
	equipment_inventory.get_slot(EquipmentBindableSlot.EquipmentBindableSlotKey.SHOES).set_stack(Stack.new(ItemDatabase.get_item("Basic Warrior Shoe"), 1))
	
	bindable_slot_manager.init_inventory(key, entity)
