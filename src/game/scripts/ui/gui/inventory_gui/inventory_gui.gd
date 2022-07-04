extends Node2D

var is_ready: bool = false

@onready var drag_preview: DragPreview = $DragPreview
@onready var equipments_container: DictionaryInventoryContainer = $Inventory
@onready var tooltip: Tooltip = $Tooltip

var inventory: Inventory

var player: Player

func _unhandled_input(event):
	if not is_ready:
		return

	if event.is_action_pressed("ui_inventory"):
		equipments_container.visible = !equipments_container.visible
		hide_item_tooltip()

func _init():
	EventBus.connect("_player_initialized", _on_player_initialized)

func _on_player_initialized(player_reference: Player):
	player = player_reference
	
	equipments_container.inventory = player.data.get_inventory(Inventory.InventoryCategory.CHARACTER_EQUIPMENTS)
	inventory = equipments_container.inventory
	
	for slot_container in equipments_container.get_slot_containers():
		slot_container.stack_container.connect("gui_input", slot_container_gui_input, [slot_container])
		slot_container.stack_container.connect("mouse_entered", show_item_tooltip, [slot_container])
		slot_container.stack_container.connect("mouse_exited", hide_item_tooltip)
	
	is_ready = true


###
# BUILT-IN
# DRAG AND DROP
###
func slot_container_gui_input(event, slot_container: SlotContainer):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			drag_stack_container(slot_container)
			# player.save()
			hide_item_tooltip()
		
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			split_stack_container(slot_container)
			# player.save()
			hide_item_tooltip()

func drag_stack_container(slot_container: SlotContainer):
	var slot_index = slot_container.slot.id
	var slot: Slot = slot_container.slot

	# pick item
	if not slot.is_empty() and drag_preview.is_empty():
		drag_preview.set_stack( inventory.remove_stack(slot_index) )

	# check if slot accepts item
	elif not slot.is_empty() and not slot_container.is_accepting_item(drag_preview.stack.item):
		return
	
	# drop item
	elif slot.is_empty() and not drag_preview.is_empty():
		drag_preview.set_stack( inventory.set_stack(slot_index, drag_preview.stack) )
	
	elif not slot.is_empty() and not drag_preview.is_empty():
		# stack item
		if slot.get_item_name() == drag_preview.stack.get_item_name() and slot.is_item_stackable():
			var remaining_quantity := inventory.set_stack_quantity(slot_index, drag_preview.stack.quantity)
			
			if remaining_quantity == 0:
				drag_preview.set_stack(null)
			else:
				drag_preview.stack.quantity = remaining_quantity
		
		# swap items
		else:
			drag_preview.set_stack( inventory.set_stack(slot_index, drag_preview.stack) )

func split_stack_container(slot_container: SlotContainer):
	var slot: Slot = slot_container.slot

	if slot.is_empty() or not slot.is_item_stackable():
		return
	
	var split_amount := ceil(slot.stack.quantity / 2.0)

	if not drag_preview.is_empty() and slot.get_item_name() == drag_preview.get_item_name():
		var remaining_quantity := drag_preview.stack.fill_to(split_amount)

		if remaining_quantity == 0:
			drag_preview.set_stack(null)
			slot.stack.fill_to(-remaining_quantity)
		else:
			slot.stack.fill_to(remaining_quantity)
	
	if drag_preview.is_empty():
		var new_stack := Stack.new(slot.stack.item, split_amount)
		slot.stack.fill_to(-split_amount)
		if slot.stack.quantity == 0:
			slot.set_stack(null)
		drag_preview.set_stack(new_stack)
		

###
# BUILT-IN
# TOOLTIP
###
func show_item_tooltip(slot_container):
	var slot: Slot = slot_container.slot

	if not slot.is_empty() and drag_preview.is_empty():
		tooltip.display_info(slot.get_item_name())
		tooltip.show()
	else:
		tooltip.hide()

func hide_item_tooltip():
	tooltip.hide()
