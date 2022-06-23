extends Node2D
class_name UI

# https://medium.com/@thrivevolt/making-a-grid-inventory-system-with-godot-727efedb71f7

@onready var drag_preview: DragPreview = $DragPreview
@onready var inventory_container: ArrayInventoryContainer = $ArrayInventoryContainer
var inventory: ArrayInventory

#func _unhandled_input(event):
#	if event.is_action_pressed("ui_inventory"):
#		inventory_container.visible = !inventory_container.visible



func _ready():
	inventory = ArrayInventory.new(20)
	inventory_container.inventory = inventory
	
	for slot in inventory.slots:
		if randf() > 0.5:
			slot.set_stack(Stack.new(ItemDatabase.get_item("Basic Warrior Chest Plate"), 1))
	
	inventory_container.init_inventory()
	var index := 0 
	
	for slot_container in inventory_container.get_slot_containers():
		slot_container.stack_container.connect("gui_input", slot_container_gui_input, [index])
		index += 1

func slot_container_gui_input(event, index: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			drag_item_container(index)

func drag_item_container(slot_index: int):
	var slot: Slot = inventory.get_slot(slot_index)

	# pick item
	if not slot.is_empty() and drag_preview.is_empty():
		drag_preview.set_stack( inventory.remove_stack(slot_index) )
	# drop item
	elif slot.is_empty() and not drag_preview.is_empty():
		drag_preview.set_stack( inventory.set_stack(slot_index, drag_preview.stack) )
	# swap items
	elif not slot.is_empty() and not drag_preview.is_empty():
		drag_preview.set_stack( inventory.set_stack(slot_index, drag_preview.stack) )
