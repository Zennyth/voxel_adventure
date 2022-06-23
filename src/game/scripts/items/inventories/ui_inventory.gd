extends Node2D
class_name InventoryContainer

@onready var slot_containers = $GridContainer
var holding_item_container: ItemContainer
var inventory: Inventory


func _init(inventory_reference: Inventory):
	inventory = inventory_reference


func _ready():
	for slot_container in slot_containers.get_tree().get_nodes_in_group('slots'):
		slot_container_container.connect("gui_input", slot_container_gui_input, [slot_container])


func slot_container_gui_input(event: InputEvent, slot_container: SlotContainer):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_LEFT_BUTTON && event.pressed:
			if holding_item_container != null:
				if slot_container.is_empty():
					left_click_empty_slot_container(slot_container)
				else:
					if holding_item_container.get_name() != slot_container.get_item_name():
						left_click_different_item(event, slot_container)
					else:
						left_click_same_item(slot_container)
			elif not slot_container.is_empty():
				left_click_not_holding(slot_container)



func able_to_put_into_slot_container(slot_container: Slot) -> bool:
	return true

func left_click_empty_slot_container(slot_container: Slot):
	if not able_to_put_into_slot_container(slot_container):
		return
	# PlayerInventory.add_item_to_empty_slot_container(find_parent("UserInterface").holding_item_container, slot_container)
	slot_container.putIntoSlot(holding_item_container)
	holding_item_container = null

func left_click_different_item(event: InputEvent, slot_container: Slot):
	if not able_to_put_into_slot_container(slot_container):
		return
	# PlayerInventory.remove_item(slot_container)
	# PlayerInventory.add_item_to_empty_slot_container(find_parent("UserInterface").holding_item_container, slot_container)
	var temp_item = slot_container._item
	slot_container.pickFromSlot()
	temp_item.global_position = event.global_position
	slot_container.putIntoSlot(holding_item_container)
	holding_item_container = temp_item

func left_click_same_item(slot_container: Slot):
	if able_to_put_into_slot_container(slot_container):
		var stack_size = slot_container._item.max_stack_size
		var able_to_add = stack_size - slot_container.item.item_quantity
		if able_to_add >= holding_item_container.item_quantity:
			# PlayerInventory.add_item_quantity(slot_container, find_parent("UserInterface").holding_item_container.item_quantity)
			# slot_container.item.add_item_quantity(find_parent("UserInterface").holding_item_container.item_quantity)
			holding_item_container.queue_free()
			holding_item_container = null
		else:
			# PlayerInventory.add_item_quantity(slot_container, able_to_add)
			# slot_container.item.add_item_quantity(able_to_add)
			holding_item_container.decrease_item_quantity(able_to_add)

func left_click_not_holding(slot_container: Slot):
	# PlayerInventory.remove_item(slot_container)
	holding_item_container = slot_container._item
	slot_container.pickFromSlot()
	holding_item_container.global_position = get_global_mouse_position()
