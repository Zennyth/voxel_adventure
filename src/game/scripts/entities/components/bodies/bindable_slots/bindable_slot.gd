extends Component
class_name BindableSlot

###
# BUILT-IN
###
func _init():
	add_to_group("bindable_slots")
	mesh_instance = $"." as MeshInstance3D
	mesh_instance.mesh = null

func update_key():
	pass

###
# BUILT-IN
# Slot
###
var slot_key: String = "":
	set(value):
		slot_key = value
		if slot_key == "" or slot_key == null or slot_key.contains("null"):
			return
		item.key = "%s_%s" % [WorldState.STATE_KEYS.BINDALBE_SLOT, slot_key]
		mesh_visibility.key = "%s_%s" % [WorldState.STATE_KEYS.BINDALBE_SLOT_IS_ACTIVE, slot_key]

var item_category: Item.ItemCategory

@export var inventory_category: Inventory.InventoryCategory = Inventory.InventoryCategory.CHARACTER_COSMETIC

var slot: Slot = null:
	set(_slot):
		disconnect_from_slot()
		slot = _slot
		connect_to_slot()
		slot_changed()

func _on_stack_changed(_new_stack: Stack):
	slot_changed()
	
func slot_changed():	
	item.sync_value(slot.get_item() if slot and not slot.is_empty() else null)
	_on_is_active_changed(slot and slot.is_active)
   
func _on_is_active_changed(is_now_active: bool):
	mesh_visibility.sync_value(is_now_active)


###
# BUILT-IN
# Item
###
var item := new_property(null, null, true, {
	"on_changed": _on_item_changed,
	"parse": Database.item_classes.parse_item,
	"dump": Database.item_classes.dump_item
})

func _on_item_changed(new_item: Item):
	mesh_instance.mesh = get_mesh(new_item)


###
# BUILT-IN
# Visibility
###
var mesh_visibility := bind_property("mesh_instance.visible", null, true)

###
# BUILT-IN
# MeshInstance
###
var mesh_instance: MeshInstance3D

func get_mesh(_item: Item):
	if not _item:
		return null
	
	# TODO: Use Secondary mesh properly
	# if (item is Equipment or item is Cosmetic) and item.secondary_mesh and "Left" in name:
	# 	return item.secondary_mesh

	return _item.mesh


###
# UTILS
###
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
