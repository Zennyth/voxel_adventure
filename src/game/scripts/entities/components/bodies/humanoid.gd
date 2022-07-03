extends Body
class_name HumanoidBody
	
func _ready():
	if is_authoritative():
		bind_inventories()


func bind_inventories():
	bind_cosmetic_inventory()
	bind_equipments_inventory()

func bind_cosmetic_inventory():
	var inventory_key := Inventory.InventoryCategory.CHARACTER_COSMETIC
	var item_key := Item.ItemCategory.COSMETIC
	bind_inventory(inventory_key, item_key)

func bind_equipments_inventory():
	var inventory_key := Inventory.InventoryCategory.CHARACTER_EQUIPMENTS
	var item_key := Item.ItemCategory.EQUIPMENT
	bind_inventory(inventory_key, item_key)

func bind_inventory(inventory_key: Inventory.InventoryCategory, item_key: int):
	bindable_slot_manager.init_inventory(inventory_key, item_key, entity)
