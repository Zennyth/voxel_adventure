extends Component
class_name BindableSlot

###
# BUILT-IN
###
func _init():
	add_to_group("bindable_slots")
	mesh_instance = $"." as MeshInstance3D
	mesh_instance.mesh = null


###
# BUILT-IN
# Slot
###
var slot_key: String = ""
var item_category: Item.ItemCategory

@export var inventory_category: Inventory.InventoryCategory = Inventory.InventoryCategory.CHARACTER_COSMETIC

var slot: Slot = null:
	set(_slot):
		disconnect_from_slot()
		slot = _slot
		connect_to_slot()
		update_slot()

func _on_stack_changed(_new_stack: Stack):
	update_slot()


###
# BUILT-IN
# MeshInstance
###
var mesh_instance: MeshInstance3D

func visible(is_visible_var: bool):
	if mesh_instance: mesh_instance.visible = is_visible_var
	if is_authoritative():
		update_stable_state()

func is_visible():
	return slot and slot.is_active

func _on_is_active_changed(is_now_active: bool):
	visible(is_now_active)

func update_slot():
	if not slot or slot.is_empty():
		mesh_instance.mesh = null
	else:
		mesh_instance.mesh = get_mesh(slot.stack.item)
	
	visible(slot.is_active if slot else false)
	
	if is_authoritative():
		update_stable_state()


###
# UTILS
###
func get_mesh(item: Item):
	if not item:
		return null
	
	# TODO: Use Secondary mesh properly
	# if (item is Equipment or item is Cosmetic) and item.secondary_mesh and "Left" in name:
	# 	return item.secondary_mesh

	return item.mesh

func connect_to_slot():
	if not slot:
		return
	
	slot._stack_changed.connect(_on_stack_changed)
	slot._is_active_changed.connect(_on_is_active_changed)

func disconnect_from_slot():
	if not slot:
		return
	
	slot._stack_changed.disconnect(_on_stack_changed)
	slot._is_active_changed.disconnect(_on_is_active_changed)


###
# OVERRIDE
###
func get_sync_key() -> String:
	return WorldState.STATE_KEYS.BINDALBE_SLOT + "_" + str(slot_key)

func get_sync_is_active_key() -> String:
	return WorldState.STATE_KEYS.BINDALBE_SLOT_IS_ACTIVE + "_" + str(slot_key)

func get_stable_state(state: Dictionary = { }, component: Node = self) -> Dictionary:
	
	if slot_key != null:
		state[get_sync_key()] = slot.get_item_name() if slot and not slot.is_empty() else ""
	
	state[get_sync_is_active_key()] = is_visible()
	
	return super.get_stable_state(state, component)

func set_stable_state(new_state: Dictionary, component: Node = self) -> void:
	var identifier := get_sync_key()
	
	if identifier in new_state:
		if new_state[identifier] == "":
			mesh_instance.mesh = null
		else:
			var item: Item = Database.items.get_by_name(new_state[identifier])
			mesh_instance.mesh = get_mesh(item)
	
	if get_sync_is_active_key() in new_state:
		visible(new_state[get_sync_is_active_key()])
	
	super.set_stable_state(new_state, component)
