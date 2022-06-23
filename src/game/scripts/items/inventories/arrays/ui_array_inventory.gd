extends Node2D
class_name ArrayInventoryContainer

@export slot_container_template: SlotContainer


@onready var slot_containers = $GridContainer
var dragged_stack_container: StackContainer
var inventory: ArrayInventory


func _init(inventory_reference: ArrayInventory):
	inventory = inventory_reference


func _ready():
	if not inventory or not slot_container_template:
    return
  
  for index in inventory.get_slot_number():
    var slot: Slot = inventory.get_slot(index)
    var slot_container := slot_container_template.instanciate()

    slot_container.add_child(slot_container)
    slot_container.set_slot(slot)


func get_slot_containers():
  return slot_containers.get_children()