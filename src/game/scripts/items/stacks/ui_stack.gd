extends Control
class_name StackContainer

@onready var quantity: Label = $Quantity
@onready var item_container: ItemContainer = $ItemContainer

var stack: Stack:
	set(_stack):
		stack = _stack
		if stack:
			stack.connect("stack_updated", _on_stack_updated)
		update_ui()

func set_stack(_stack: Stack):
	stack = _stack

func _on_stack_updated(new_stack):
	update_ui()

func update_ui():
	item_container.set_item(stack.item if stack else null)
	quantity.text = str(stack.quantity) if stack else ""

func is_empty():
	return stack == null or stack.is_empty()
