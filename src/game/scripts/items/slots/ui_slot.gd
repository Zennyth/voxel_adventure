extends Panel
class_name SlotContainer

var default_texture = preload("res://assets/items/inventories/item_slot_default_background.png")
var empty_texture = preload("res://assets/items/inventories/item_slot_empty_background.png")

var default_style := StyleBoxTexture.new()
var empty_style := StyleBoxTexture.new()

@onready var stack_container: StackContainer = $StackContainer

var slot: Slot = null:
	set(_slot):
		slot = _slot

		stack_container.set_stack(slot.stack)
		update_ui()

func set_slot(_slot: Slot):
	slot = _slot

func _on_stack_changed(_new_stack: Stack):
	update_ui()


func update_ui():
	set('theme_override_styles/panel', empty_style if slot and slot.stack == null else default_style)

func _ready():
	add_to_group("slots")
	default_style.texture = default_texture
	empty_style.texture = empty_texture

func is_empty() -> bool:
	return stack == null or stack.is_empty()

func get_item_name() -> String:
	return stack.item.name