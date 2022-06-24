extends Component
class_name BindableSlot

enum BindableSlotKey {
	CHEST_PLATE,
	AMULET,

	FACE,
	EYES,
	HELMET,

	SHOES,

	GLOVES,

	LEFT_HAND_WEAPON,
	RIGHT_HAND_WEAPON
}

@export var inventory_key: Inventory.InventoryKey = Inventory.InventoryKey.EQUIPMENT_INVENTORY
@export var slot_key: BindableSlotKey = BindableSlotKey.CHEST_PLATE

var slot: Slot = null:
	set(_slot):
		if slot: slot.disconnect("stack_changed", _on_stack_changed)
		slot = _slot
		if slot: slot.connect("stack_changed", _on_stack_changed)

func _on_stack_changed():
	if not slot or slot.is_empty():
		part.mesh = null
		return
	
	part.mesh = slot.stack.item.mesh



var part: MeshInstance3D

func _init():
	add_to_group("bindable_slots")
	part = $"." as MeshInstance3D

func get_sync_key() -> String:
	return WorldState.STATE_KEYS.BINDALBE_SLOT + "_" + slot_key


func get_stable_state(state: Dictionary = { }, component: Node = self) -> Dictionary:
	state[get_sync_key()] = slot.get_item_name()
	return super.get_stable_state(state, component)

func set_stable_state(new_state: Dictionary, component: Node = self) -> void:
	var identifier := get_sync_key()
	
	if identifier in new_state:
		var item: Item = ItemDatabase.get_item(new_state[identifier])
		part.mesh = item.mesh
	
	super.set_stable_state(new_state, component)
