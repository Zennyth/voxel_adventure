extends Component
class_name BindableSlot

var slot_key
func set_slot_key(item_class: String, category: String):
    slot_key = str(item_category) + "_" + item_class + "_" + category

var item_category: Item.ItemCategory
@export var inventory_category: Inventory.InventoryCategory = Inventory.InventoryCategory.CHARACTER_COSMETIC

var slot: Slot = null:
	set(_slot):
		if slot: slot._stack_changed.disconnect(_on_stack_changed)
		slot = _slot
		if slot: slot._stack_changed.connect(_on_stack_changed)
		update_slot()

func _on_stack_changed(_new_stack: Stack):
	update_slot()


func visible(is_visible: bool):
    part.visible = is_visible

func is_visible():
    return part.visible



func update_slot():
	if not slot or slot.is_empty():
		part.mesh = null
	else:
		part.mesh = get_mesh(slot.stack.item)
	
	if is_authoritative():
		update_stable_state()

var part: MeshInstance3D

func _init():
	add_to_group("bindable_slots")
	part = $"." as MeshInstance3D
	part.mesh = null


func get_mesh(item: Item):
	if not item:
		return null

	if (item is Equipment or item is Cosmetic) and item.secondary_mesh and "Left" in name:
		return item.secondary_mesh

	return item.mesh


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
			var item: Item = Database.items.get(new_state[identifier])
			part.mesh = get_mesh(item)
	
	super.set_stable_state(new_state, component)
