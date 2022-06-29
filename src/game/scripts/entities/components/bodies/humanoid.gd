extends Body
class_name HumanoidBody
	
func _ready():
	super._ready()
	
	if is_authoritative():
		init_cosmetic_inventory()


func init_cosmetic_inventory():
	var key := Inventory.InventoryCategory.CHARACTER_COSMETIC
	
	entity.inventories[key] = DictionaryInventory.new(bindable_slot_manager.inventory_keys[key])
	
	var inventory: Inventory = entity.inventories[key]
	
	# var db := Database.item
	# inventory.get_slot(Cosmetic.CosmeticCategory.FACE).set_stack(Stack.new(db.get("Human Face 1"), 1))
	# inventory.get_slot(Cosmetic.CosmeticCategory.CHEST).set_stack(Stack.new(db.get("Basic Warrior Chest Plate"), 1))
	# inventory.get_slot(Cosmetic.CosmeticCategory.HANDS).set_stack(Stack.new(db.get("Basic Warrior Glove"), 1))
	# inventory.get_slot(Cosmetic.CosmeticCategory.FEET).set_stack(Stack.new(db.get("Basic Warrior Shoe"), 1))
	
	bindable_slot_manager.init_inventory(key, Item.ItemCategory.COSMETIC, entity)
