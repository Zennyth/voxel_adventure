extends Node2D

# https://medium.com/@thrivevolt/making-a-grid-inventory-system-with-godot-727efedb71f7

@onready var drag_preview: DragPreview = $DragPreview
var inventory_container: ArrayInventoryContainer
var inventory: ArrayInventory

func _unhandled_input(event):
	if event.is_action_pressed("ui_inventory"):
		inventory_container.visible = !inventory_container.visible



func _ready():
  inventory = ArrayInventory.new(20)
  inventory_container = ArrayInventoryContainer.new(inventory)
  add_child(inventory_container)

  for slot_container in inventory_container.get_slot_containers():
    slot_container.connect("gui_input", slot_container_gui_input, [index])

    if randf() > .5:
      slot_container.slot.set_stack(Stack.new(ItemDatabase.get_item("Basic Warrior Chest Plate"), 1))



func slot_container_gui_input(event, index: int):
  if event is InputEventMouseButton:
    if event.button_index == MOUSE_LEFT_BUTTON && event.pressed:
      drag_item_container(index)

func drag_item_container(slot_index: int):
  var slot: Slot = inventory.get_slot(slot_index)

  # pick item
  if not slot.is_empty() and drag_preview.is_empty():
    drag_preview.set_stack( inventory.remove_stack(index) )
  # drop item
  elif slot.is_empty() and not drag_preview.is_empty():
    drag_preview.set_stack( inventory.set_stack(index, drag_preview.stack) )
  # swap items
  elif not slot.is_empty() and not drag_preview.is_empty():
    drag_preview.set_stack( inventory.set_stack(index, drag_preview.stack) )