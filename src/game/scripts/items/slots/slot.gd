class_name Slot
extends Resource

@export var id: int

###
# BUILT-IN
###
func _init(_id = null, initital_stack: Stack = null):
	if _id: id = _id
	if initital_stack: Stack = initital_stack


###
# BUILT-IN
# Stack
###
signal _stack_changed(new_stack: Stack)

@export var stack: Resource:
    set(_stack):
        stack = _stack
        _stack_changed.emit(stack)

func set_stack(_stack: Stack):
    stack = _stack


###
# BUILT-IN
# IsActive
###
signal _is_active_changed(is_now_active: bool)

@export var is_active: bool = true:
    set(is_now_active):
        is_active = is_now_active
        _is_active_changed.emit(is_active)

###
# UTILS
###
func is_empty() -> bool:
	return stack == null or stack.is_empty()

func get_item_name() -> String:
	return stack.get_item_name()

func is_item_stackable() -> bool:
	return stack.is_item_stackable()
