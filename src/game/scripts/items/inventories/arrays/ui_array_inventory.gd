extends Node2D
class_name ArrayInventoryContainer

@export var slot_container_template: PackedScene


@onready var slot_containers = $GridContainer
var dragged_stack_container: StackContainer
var inventory: ArrayInventory


func _init(inventory_reference: ArrayInventory = null):
	inventory = inventory_reference

func init_inventory():
	for index in inventory.get_slot_number():
		var slot: Slot = inventory.get_slot(index)
		var slot_container := slot_container_template.instantiate() as SlotContainer

		slot_containers.add_child(slot_container)
		slot_container.set_slot(slot)


func _ready():
	if not slot_container_template or not inventory:
		return
	
#	if not inventory:
#		inventory = ArrayInventory.new(20)
#		for slot in inventory.slots:
#			if randf() > 0.5:
#				slot.set_stack(Stack.new(ItemDatabase.get_item("Basic Warrior Chest Plate"), 1))
  
	init_inventory()

func get_slot_containers():
	return slot_containers.get_children()
