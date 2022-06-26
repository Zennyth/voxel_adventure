extends Component
class_name BindableSlot

var slot_key

@export var inventory_key: Inventory.InventoryKey = Inventory.InventoryKey.EQUIPMENT_INVENTORY

var slot: Slot = null:
	set(_slot):
		if slot: slot.disconnect("stack_changed", _on_stack_changed)
		slot = _slot
		if slot: slot.connect("stack_changed", _on_stack_changed)
		update_slot()

func _on_stack_changed():
	update_slot()

func update_slot():
	if not slot or slot.is_empty():
		part.mesh = null
	else:
		part.mesh = slot.stack.item.mesh
	
	if is_authoritative():
		update_stable_state()

var part: MeshInstance3D

func _init():
	add_to_group("bindable_slots")
	part = $"." as MeshInstance3D
	part.mesh = null

func get_sync_key() -> String:
	return WorldState.STATE_KEYS.BINDALBE_SLOT + "_" + str(slot_key)


func get_stable_state(state: Dictionary = { }, component: Node = self) -> Dictionary:
	
	if slot_key != null:
		state[get_sync_key()] = slot.get_item_name() if slot and not slot.is_empty() else ""
	
	return super.get_stable_state(state, component)

func set_stable_state(new_state: Dictionary, component: Node = self) -> void:
	var identifier := get_sync_key()
	
	if identifier in new_state:
		if new_state[identifier] == "":
			part.mesh = null
		else:
			var item: Item = ItemDatabase.get_item(new_state[identifier])
			part.mesh = item.mesh
	
	super.set_stable_state(new_state, component)
