class_name Slot
extends Resource

signal _stack_changed(new_stack: Stack)
signal _item_display_changed(is_displayed: bool)

@export var stack: Resource:
	set(_stack):
		stack = _stack
		_stack_changed.emit(stack)

@export var id: int

var is_item_diplayed: bool:
	set(_is_item_diplayed):
		is_item_diplayed = _is_item_diplayed
		_item_display_changed.emit(is_item_diplayed)

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
