class_name Slot
extends Resource

signal stack_changed(new_stack: Stack)

@export var stack: Resource:
	set(_stack):
		stack = _stack
		stack_changed.emit(stack)

@export var id: int

func _init(_id = null, initital_stack: Stack = null):
	if _id: id = _id
	if initital_stack: stack = initital_stack

func set_stack(_stack: Stack):
	stack = _stack

func is_empty() -> bool:
	return stack == null or stack.is_empty()

func get_item_name() -> String:
	return stack.get_item_name()

func is_item_stackable() -> bool:
	return stack.is_item_stackable()
