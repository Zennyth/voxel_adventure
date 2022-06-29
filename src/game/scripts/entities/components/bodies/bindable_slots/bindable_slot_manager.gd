extends Component
class_name BindableSlotManager

var inventory_keys := {}
var inventory: DictionaryInventory

var bindable_slots := []

func findNodeDescendantsInGroup(node: Node, groupName: String) -> Array:
	var descendantsInGroup := []
	for child in node.get_children():
		if child.is_in_group(groupName):
			descendantsInGroup.append(child)
		descendantsInGroup += findNodeDescendantsInGroup(child, groupName)
	return descendantsInGroup

func _ready():
	bindable_slots = findNodeDescendantsInGroup(self, "bindable_slots")
	
	for bindable_slot in bindable_slots:
		bindable_slot.init(entity)
		
		if not bindable_slot.inventory_category in inventory_keys:
			inventory_keys[bindable_slot.inventory_category] = []

		inventory_keys[bindable_slot.inventory_category].append(bindable_slot.slot_key)



func init_inventory(inventory_key: Inventory.InventoryCategory, item_key: Item.ItemCategory, binded_entity: Character):
	if inventory_key in binded_entity.inventories:
		inventory = binded_entity.inventories[inventory_key]
	else:
		inventory = DictionaryInventory.new(inventory_keys[inventory_key])
		binded_entity.inventories[inventory_key] = inventory
	
	bind_slot(item_key, binded_entity.inventories[inventory_key])

	

func bind_slot(key: Item.ItemCategory, binded_inventory: Inventory):
	for bindable_slot in bindable_slots:
		if not bindable_slot.item_category or bindable_slot.item_category != key:
			continue
		
		bindable_slot.slot = binded_inventory.get_slot(bindable_slot.slot_key)


func get_stable_state(state: Dictionary = { }, component: Node = self) -> Dictionary:
	for bindable_slot in bindable_slots:
		bindable_slot.get_stable_state(state, component)
	
	return super.get_stable_state(state, component)

func set_stable_state(new_state: Dictionary, component: Node = self) -> void:
	for bindable_slot in bindable_slots:
		bindable_slot.set_stable_state(new_state, component)
	
	# print(new_state)
	super.set_stable_state(new_state, component)
