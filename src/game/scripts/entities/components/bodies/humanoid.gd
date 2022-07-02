extends Body
class_name HumanoidBody
	
func _ready():
	super._ready()
	
	if is_authoritative():
		bind_cosmetic_inventory()


func bind_cosmetic_inventory():
	var inventory_key := Inventory.InventoryCategory.CHARACTER_COSMETIC
	var item_key := Item.ItemCategory.COSMETIC
	bindable_slot_manager.init_inventory(inventory_key, item_key, entity)
