extends Panel
class_name SlotContainer

var default_texture = preload("res://assets/items/inventories/item_slot_default_background.png")
var empty_texture = preload("res://assets/items/inventories/item_slot_empty_background.png")

var default_style := StyleBoxTexture.new()
var empty_style := StyleBoxTexture.new()
var disabled_style := StyleBoxTexture.new()

var key

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
		
		slot._stack_changed.connect(_on_stack_changed)
		update_ui()
			
func set_slot(_slot: Slot):
	slot = _slot
		
func is_empty() -> bool:
	return slot == null or slot.is_empty()

func get_item_name() -> String:
	if slot == null or slot.stack == null:
		return ""
	
	return slot.get_item_name()

func _on_stack_changed(_new_stack: Stack):
	update_ui()


###
# BUILT-IN
# SlotContainer
###
func _ready():
	add_to_group("slot_containers")
	default_style.texture = default_texture
	empty_style.texture = empty_texture
	disabled_style.texture = empty_texture
	
	update_ui()
	

func update_ui():
	stack_container.set_stack(slot.stack if slot else null)
	set('theme_override_styles/panel', get_style())

func get_style() -> StyleBoxTexture:
	if slot == null:
		return disabled_style
	elif slot.is_empty():
		return empty_style
	
	return default_style

func is_accepting_item_reference(_item: ItemReference) -> bool:
	return true
