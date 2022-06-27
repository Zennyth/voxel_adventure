extends Panel
class_name SlotContainer

var default_texture = preload("res://assets/items/inventories/item_slot_default_background.png")
var empty_texture = preload("res://assets/items/inventories/item_slot_empty_background.png")

var default_style := StyleBoxTexture.new()
var empty_style := StyleBoxTexture.new()

var id

@onready var stack_container: StackContainer = $StackContainer


###
# BUILT-IN
# Slot
###
var slot: Slot = null:
	set(_slot):
		slot = _slot

		if not slot:
			return
		
		slot.connect("stack_changed", _on_stack_changed)
		update_ui()
			
func set_slot(_slot: Slot):
	slot = _slot
		
func is_empty() -> bool:
	return slot == null or slot.is_empty()

func get_item_name() -> String:
	if slot == null or slot.stack == null:
		return ""
	
	return slot.stack.get_item_name()

func _on_stack_changed():
	update_ui()

	
	
	
###
# BUILT-IN
# SlotContainer
###
func _ready():
	add_to_group("slots")
	default_style.texture = default_texture
	empty_style.texture = empty_texture
	

func update_ui():
	stack_container.set_stack(slot.stack)
	set('theme_override_styles/panel', empty_style if slot and slot.stack == null else default_style)


func is_accepting_item(item: Item) -> bool:
	return true
