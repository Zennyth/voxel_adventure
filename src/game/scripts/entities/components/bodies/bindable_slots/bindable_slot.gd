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
	item = create_property(null, item_key, self.parse_item, self.dump_item)
	item._property_changed.connect(_on_item_changed)
	
	is_mesh_visible = create_property(false, visibility_key)
	is_mesh_visible._property_changed.connect(_on_mesh_visible_changed)

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
	if slot and not slot.is_empty():
		item.set_property(slot.get_item())
		mesh_instance.mesh = get_mesh(item.get_property())
	
	_on_is_active_changed(slot.is_active if slot else false)
   
func _on_is_active_changed(is_now_active: bool):
	if is_mesh_visible:
		is_mesh_visible.set_property(is_now_active)


###
# BUILT-IN
# Item
###
var item_key: String:
	get:
		return "%s_%s" % [WorldState.STATE_KEYS.BINDALBE_SLOT, slot_key]

func parse_item(data) -> Item:
	if data == null:
		return null

	var item = Database.item_classes.get_by_name(data["i"])

	for property in data["p"]:
		var vt = data["p"][property]
		
		if "t" in vt and vt["t"].contains("Mesh"):
			item[property] = bytes2var_with_objects(data["p"][property]["v"])
		else:
			item[property] = vt["v"]

	return item

func dump_item(new_item):
	if new_item == null:
		return null

	var data = {
		"i": new_item.get_item_class(),
		"p": {}
	}

	for property in new_item.get_property_list():
		var value = new_item.get(property["name"])

		if value == null or property["usage"] != 8199:
			continue

		data["p"][property["name"]] = {
			"v": value
		}
		
		if value is Object:
			data["p"][property["name"]]["t"] = value.get_class()
			
			if value.get_class().contains("Mesh"):
				data["p"][property["name"]]["v"] = var2bytes_with_objects(value)

	return data

func _on_item_changed(new_item: Item):
	# print(new_item)
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
