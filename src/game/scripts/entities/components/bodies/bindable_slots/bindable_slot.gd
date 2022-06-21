@tool

extends MeshInstance3D
class_name BindableSlot

enum Slots {
	COSMETIC,
	EQUIPMENT,
	ITEM
}
@export var _slot: Slots = Slots.EQUIPMENT:
	set(slot):
		remove_from_group(get_slot_group(_slot))
		_slot = slot
		add_to_group(get_slot_group(_slot))
		add_to_group("slots")


static func get_slot_group(slot: Slots) -> String:
	return "slot_" + str(slot)

var _item: ItemResource = null:
	set(item):
		if not item or not item.mesh:
			return
		
		_item = item
		mesh = _item.mesh

func change_item(new_item: ItemResource):
	_item = new_item

@export var initial_item: Resource = null:
	set(item):
		initial_item = item
		_item = initial_item

func _ready():
	_item = initial_item
	add_to_group(get_slot_group(_slot))
	add_to_group("slots")

func is_empty() -> bool:
	return _item != null
