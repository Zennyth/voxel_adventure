extends Resource
class_name ItemResource

@export var name: String = ""
@export var is_collectable: bool = true

@export var is_stackable: bool = true
@export var max_stack_size: int = 1:
	get:
		return max_stack_size if is_stackable else 1
	set(size):
		max_stack_size = size if is_stackable else 1

@export var mesh: Resource
@export var icon: Resource

enum ItemType {
	EQUIPMENT,
	COSMETIC,
}
