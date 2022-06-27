extends Body
class_name HumanoidBody

var humanoid: Humanoid
	
func _ready():
	super._ready()
	
	if not entity is Humanoid:
		print("Entity: ", entity, " is not a Humanoid !")
	
	if is_authoritative():
		init_cosmetic_inventory()

func init_cosmetic_inventory():
	var key := Item.ItemCategory.COSMETIC
	
	entity.inventories[key] = DictionaryInventory.new(bindable_slot_manager.slot_keys[key])
	
	var inventory: Inventory = entity.inventories[key]
	
	inventory.get_slot(Cosmetic.CosmeticCategory.FACE).set_stack(Stack.new(ItemDatabase.get_item("Human Face 1"), 1))
	inventory.get_slot(Cosmetic.CosmeticCategory.CHEST).set_stack(Stack.new(ItemDatabase.get_item("Basic Warrior Chest Plate"), 1))
	inventory.get_slot(Cosmetic.CosmeticCategory.HANDS).set_stack(Stack.new(ItemDatabase.get_item("Basic Warrior Glove"), 1))
	inventory.get_slot(Cosmetic.CosmeticCategory.FEET).set_stack(Stack.new(ItemDatabase.get_item("Basic Warrior Shoe"), 1))
	
	bindable_slot_manager.init_inventory(key, entity)
