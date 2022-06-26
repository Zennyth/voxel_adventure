extends Component
class_name BindableSlotManager

var slot_keys := {}
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
		
		if not bindable_slot.inventory_key in slot_keys:
			slot_keys[bindable_slot.inventory_key] = []

		slot_keys[bindable_slot.inventory_key].append(bindable_slot.slot_key)

func init_inventory(key: Inventory.InventoryKey, entity: Character):
	if key in entity.inventories:
		inventory = entity.inventories[key]
	else:
		inventory = DictionaryInventory.new(slot_keys[key])
		entity.inventories[key] = inventory

	for bindable_slot in bindable_slots:
		if not bindable_slot.inventory_key or bindable_slot.inventory_key != key:
			continue
		
		bindable_slot.slot = inventory.get_slot(bindable_slot.slot_key)

func get_stable_state(state: Dictionary = { }, component: Node = self) -> Dictionary:
	for bindable_slot in bindable_slots:
		bindable_slot.get_stable_state(state, component)
	
	return super.get_stable_state(state, component)

func set_stable_state(new_state: Dictionary, component: Node = self) -> void:
	for bindable_slot in bindable_slots:
		bindable_slot.set_stable_state(new_state, component)
	
	# print(new_state)
	super.set_stable_state(new_state, component)
