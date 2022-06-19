@tool

extends MeshInstance3D
class_name BodySlot

enum Slots {
    COSMETIC = "COSMETIC",
    EQUIPMENT = "EQUIPMENT",
    ITEM = "ITEM"
}
@export var slot: Slots = Slots.EQUIPMENT

var _item: ItemResource = null:
	set(item):
		if not item or not item.mesh:
			return
		
		_item = item
		mesh = _item.mesh

@export var initial_item: Resource = null:
	set(item):
		initial_item = item
		_item = initial_item

func _ready():
	_item = initial_item
	add_to_group(slot)
	add_to_group("slots")

func is_empty() -> bool:
	return _item != null
