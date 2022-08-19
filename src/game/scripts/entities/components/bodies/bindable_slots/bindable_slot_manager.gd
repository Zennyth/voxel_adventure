extends Component
class_name BindableSlotManager

var inventory_keys := {}
var bindable_slots := []

func _ready():
	bindable_slots = NodeUtils.findNodeDescendantsInGroup(self, "bindable_slots")
	
	for bindable_slot in bindable_slots:
		bindable_slot.init(entity)
		
		if not bindable_slot.inventory_category in inventory_keys:
			inventory_keys[bindable_slot.inventory_category] = []

		inventory_keys[bindable_slot.inventory_category].append(bindable_slot.slot_key)

func init_inventory(inventory_key: Inventory.InventoryCategory, character: Character):
	if not character.data.has_inventory(inventory_key):
		character.data.set_inventory(inventory_key, DictionaryInventory.new(inventory_keys[inventory_key]))
	
	bind_slots(inventory_key, character.data.get_inventory(inventory_key))

func bind_slots(inventory_key: Inventory.InventoryCategory, binded_inventory: Inventory):
	for bindable_slot in bindable_slots:
		if bindable_slot.inventory_category == null or bindable_slot.inventory_category != inventory_key:
			continue

		bindable_slot.slot = binded_inventory.get_slot(bindable_slot.slot_key)
