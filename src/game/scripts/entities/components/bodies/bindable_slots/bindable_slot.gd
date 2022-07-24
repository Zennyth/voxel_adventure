extends Component
class_name BindableSlot

###
# BUILT-IN
###
var item: SyncProperty

func _init():
	add_to_group("bindable_slots")
	mesh_instance = $"." as MeshInstance3D
	mesh_instance.mesh = null

func update_key():
	pass

func entity_ready():
	super.entity_ready()
	item = create_property(null, item_key, true, {
		"on_changed": _on_item_changed,
		"parse": Database.item_classes.parse_item,
		"dump": Database.item_classes.dump_item
	})
	
	is_mesh_visible = create_property(false, visibility_key, true, {
		"on_changed": _on_mesh_visible_changed,
	})

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
		slot_changed()

func _on_stack_changed(_new_stack: Stack):
	slot_changed()
	
func slot_changed():
	if slot_key == "0_3_5":
		print(slot.get_item(), name)
	
	item.set_property(slot.get_item() if slot and not slot.is_empty() else null)
	_on_is_active_changed(slot.is_active if slot else false)
   
func _on_is_active_changed(is_now_active: bool):
	is_mesh_visible.set_property(is_now_active)


###
# BUILT-IN
# Item
###
var item_key: String:
	get:
		return "%s_%s" % [WorldState.STATE_KEYS.BINDALBE_SLOT, slot_key]

func _on_item_changed(new_item: Item):
#	if slot_key == "0_3_5":
#		print(new_item, name)
	
	mesh_instance.mesh = get_mesh(new_item)


###
# BUILT-IN
# Visibility
###
var visibility_key: String:
	get:
		return "%s_%s" % [WorldState.STATE_KEYS.BINDALBE_SLOT_IS_ACTIVE, slot_key]

var is_mesh_visible: SyncProperty

func _on_mesh_visible_changed(is_mesh_now_visible: bool):
	mesh_instance.visible = is_mesh_now_visible

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
