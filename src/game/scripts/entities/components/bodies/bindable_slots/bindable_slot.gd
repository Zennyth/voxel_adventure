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
		slot_changed()

func _on_stack_changed(_new_stack: Stack):
	slot_changed()
    
func slot_changed():
    if not slot or slot.is_empty():
        item.set_property(null)
    else:
        item.set_property(slot.get_item())
        
    _on_is_active_changed(slot.is_active if slot else false)
       
func _on_is_active_changed(is_now_active: bool):
    is_mesh_visible.set_property(is_now_active)


###
# BUILT-IN
# Item
###
var item_key: String:
    get():
	    return "%s_%s" % [WorldState.STATE_KEYS.BINDALBE_SLOT, slot_key]

var item := SyncProperty.new(null, item_key, self, Item.parse)
item._property_changed.connect(_on_item_changed)

func _on_item_changed(new_item: Item):
    mesh_instance.mesh = get_mesh(new_item)


###
# BUILT-IN
# Visibility
###
var visibility_key: String:
    get():
	    return "%s_%s" % [WorldState.STATE_KEYS.BINDALBE_SLOT_IS_ACTIVE, slot_key]

var is_mesh_visible := SyncProperty.new(false, visibility_key, self)
is_mesh_visible._property_changed.connect(_on_mesh_visible_changed)

func _on_mesh_visible_changed(is_mesh_now_visible: bool):
    mesh_instance.visible = is_mesh_now_visible

###
# BUILT-IN
# MeshInstance
###
var mesh_instance: MeshInstance3D

func get_mesh(item: Item):
	if not item:
		return null
	
	# TODO: Use Secondary mesh properly
	# if (item is Equipment or item is Cosmetic) and item.secondary_mesh and "Left" in name:
	# 	return item.secondary_mesh

	return item.mesh


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