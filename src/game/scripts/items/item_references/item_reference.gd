extends Resource
class_name ItemReference

@export var name: String = ""
@export var mesh: Resource

@export var is_collectable: bool = true

@export var is_stackable: bool = true
@export var max_stack_size: int = 1:
	get:
		return max_stack_size if is_stackable else 1
	set(size):
		max_stack_size = size if is_stackable else 1

enum Category {
	EQUIPMENT,
	COSMETIC,
	MATERIAL,
}
@export var category: Category


static func get_key(_identifier = null) -> String:
	return ""
