extends Resource
class_name Item

@export var name: String = ""
@export var is_collectable: bool = true

@export var is_stackable: bool = true
@export var max_stack_size: int = 1:
	get:
		return max_stack_size if is_stackable else 1
	set(size):
		max_stack_size = size if is_stackable else 1

@export var mesh: Resource:
	set(_mesh):
		mesh = _mesh

enum ItemCategory {
	EQUIPMENT,
	COSMETIC,
	MATERIAL,
}
@export var item_category: ItemCategory


static func get_key(_identifier = null) -> String:
	return ""


####
## BUILT-IN
## Serializable
####
static func get_item_class() -> String:
	return "Item"

func get_class() -> String:
	return "Item"
