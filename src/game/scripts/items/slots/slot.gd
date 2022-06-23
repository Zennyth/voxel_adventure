class_name Slot
extends Object

signal stack_changed

var stack: Stack:
  set(_stack):
    stack = _stack
    stack_changed.emit(stack)
var id

func _init(_id, initital_stack: Stack = null):
  id = _id
  stack = initital_stack

func set_stack(_stack: Stack):
  stack = _stack

func is_empty() -> bool:
  return stack == null or stack.is_empty()