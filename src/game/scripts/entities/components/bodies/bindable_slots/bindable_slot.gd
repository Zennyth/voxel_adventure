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
# Visibility
###
var is_mesh_visible := SyncProp.new(mesh_instance.visible, get_sync_is_active_key(), self)

func get_sync_is_active_key() -> String:
	return WorldState.STATE_KEYS.BINDALBE_SLOT_IS_ACTIVE + "_" + str(slot_key)
    
func _on_is_active_changed(is_now_active: bool):
    is_mesh_visible.set_property(is_now_active)

###
# BUILT-IN
# MeshInstance
###
var mesh_instance: MeshInstance3D

func get_sync_key() -> String:
	return WorldState.STATE_KEYS.BINDALBE_SLOT + "_" + str(slot_key)

func update_slot():
	if not slot or slot.is_empty():
		item_mesh.set_property(null)
	else:
		item_mesh.set_property(get_mesh(slot.get_item()))
	
    is_mesh_visible.set_property(slot.is_active if slot else false)


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