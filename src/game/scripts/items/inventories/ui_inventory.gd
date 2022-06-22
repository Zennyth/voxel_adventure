extends Node2D
class_name Inventory

@onready var slot_container = $GridContainer 
var holding_item = null

@export var inventory_type: InventoryResource.Inventories

func _ready():
	for slot in slot_container.get_tree().get_nodes_in_group('slots'):
		slot_container.connect("gui_input", slot_gui_input, [slot])


func slot_gui_input(event: InputEvent, slot: Slot):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_LEFT_BUTTON && event.pressed:
			if holding_item != null:
				if !slot.item:
					left_click_empty_slot(slot)
				else:
					if holding_item.item_name != slot.item.item_name:
						left_click_different_item(event, slot)
					else:
						left_click_same_item(slot)
			elif slot.item:
				left_click_not_holding(slot)

func able_to_put_into_slot(slot: Slot) -> bool:
	return true

func left_click_empty_slot(slot: Slot):
	if not able_to_put_into_slot(slot):
		return
	# PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
	slot.putIntoSlot(holding_item)
	holding_item = null

func left_click_different_item(event: InputEvent, slot: Slot):
	if not able_to_put_into_slot(slot):
		return
	# PlayerInventory.remove_item(slot)
	# PlayerInventory.add_item_to_empty_slot(find_parent("UserInterface").holding_item, slot)
	var temp_item = slot._item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(holding_item)
	holding_item = temp_item

func left_click_same_item(slot: Slot):
	if able_to_put_into_slot(slot):
		var stack_size = slot._item.max_stack_size
		var able_to_add = stack_size - slot.item.item_quantity
		if able_to_add >= holding_item.item_quantity:
			# PlayerInventory.add_item_quantity(slot, find_parent("UserInterface").holding_item.item_quantity)
			# slot.item.add_item_quantity(find_parent("UserInterface").holding_item.item_quantity)
			holding_item.queue_free()
			holding_item = null
		else:
			# PlayerInventory.add_item_quantity(slot, able_to_add)
			# slot.item.add_item_quantity(able_to_add)
			holding_item.decrease_item_quantity(able_to_add)

func left_click_not_holding(slot: Slot):
	# PlayerInventory.remove_item(slot)
	holding_item = slot._item
	slot.pickFromSlot()
	holding_item.global_position = get_global_mouse_position()
