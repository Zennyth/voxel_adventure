extends Body
class_name HumanoidBody
	
func entity_ready():
	super.entity_ready()
	if is_authoritative():
		bind_inventories()


func bind_inventories():
	bind_cosmetic_inventory()
	bind_equipments_inventory()

func bind_cosmetic_inventory():
	var inventory_key := Inventory.InventoryCategory.CHARACTER_COSMETIC
	bind_inventory(inventory_key)

func bind_equipments_inventory():
	var inventory_key := Inventory.InventoryCategory.CHARACTER_EQUIPMENTS
	bind_inventory(inventory_key)

func bind_inventory(inventory_key: Inventory.InventoryCategory):
	bindable_slot_manager.init_inventory(inventory_key, entity)
