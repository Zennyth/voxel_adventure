extends Node2D
class_name InventoryContainer

@export var slot_container_template: PackedScene

@export var is_generating_slot_containers: bool = true
@export var is_randomizing_population: bool = false

@onready var slot_containers = $GridContainer

var inventory: Inventory:
	set(_inventory):
		inventory = _inventory
		
		if is_generating_slot_containers:
			generate_slot_containers()
		else:
			bind_slot_containers()


func _init(inventory_reference: Inventory = null):
	inventory = inventory_reference

func _ready():
	if is_randomizing_population:
		random_populate()


func random_populate():
	pass


func bind_slot_containers():
	for slot_container in get_slot_containers():
		if not slot_container is SlotContainer:
			continue

		slot_container.set_slot(inventory.get_slot(slot_container.key))


func generate_slot_containers():	
	if not inventory:
		return
	
	clean_slot_containers()
	
	for index in inventory.get_indexes():
		var slot: Slot = inventory.get_slot(index)
		var slot_container := slot_container_template.instantiate() as SlotContainer

		slot_containers.add_child(slot_container)
		slot_container.set_slot(slot)

func clean_slot_containers():
	if not slot_containers:
		return
	
	for n in get_slot_containers():
		slot_containers.remove_child(n)
		n.queue_free()

func get_slot_containers():
	return NodeUtils.findNodeDescendantsInGroup(self, "slot_containers")
