extends Component
class_name BindableSlotManager

var inventory_keys := {}
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

func init_inventory(inventory_key: Inventory.InventoryCategory, item_key: Item.ItemCategory, character: Character):
	if not character.data.has_inventory(inventory_key):
		character.data.set_inventory(inventory_key, DictionaryInventory.new(inventory_keys[inventory_key]))
	
	bind_slots(item_key, character.data.get_inventory(inventory_key))

func bind_slots(key: Item.ItemCategory, binded_inventory: Inventory):
	for bindable_slot in bindable_slots:
		if bindable_slot.item_category == null or bindable_slot.item_category != key:
			continue
		bindable_slot.slot = binded_inventory.get_slot(bindable_slot.slot_key)




func get_stable_state(state: Dictionary = { }, component: Node = self) -> Dictionary:
	for bindable_slot in bindable_slots:
		bindable_slot.get_stable_state(state, component)
	
	return super.get_stable_state(state, component)

func set_stable_state(new_state: Dictionary, component: Node = self) -> void:
	for bindable_slot in bindable_slots:
		bindable_slot.set_stable_state(new_state, component)
	
	super.set_stable_state(new_state, component)
