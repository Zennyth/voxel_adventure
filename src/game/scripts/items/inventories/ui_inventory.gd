extends Node2D
class_name InventoryContainer

@export var slot_container_template: PackedScene
@export var need_random_population: bool = false

@onready var slot_containers = $GridContainer

var inventory: Inventory:
    set(_inventory):
        clean_slot_containers()
        inventory = _inventory
        init_inventory()


func _init(inventory_reference: Inventory = null):
	inventory = inventory_reference

func _ready():
    if random_populate:
        random_populate()

func random_populate():
    pass


func clean_slot_containers():
    for n in slot_containers.get_children():
        slot_containers.remove_child(n)
        n.queue_free()

func init_inventory():
    if not inventory:
        return

    for index in inventory.get_indexes():
        var slot: Slot = inventory.get_slot(index)
        var slot_container := slot_container_template.instantiate() as SlotContainer

        slot_containers.add_child(slot_container)
        slot_container.set_slot(slot)

func get_slot_containers():
    return slot_containers.get_children()