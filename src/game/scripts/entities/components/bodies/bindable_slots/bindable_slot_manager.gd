extends Skeleton3D
class_name BindableSlotManager

var slot_keys: {}
var inventory: DictionaryInventory


func _ready():
    for bindable_slot in get_tree().get_nodes_by_groupe("bindable_slots"):
        if not bindable_slot.inventory_key in slot_keys:
            slot_keys[bindable_slot.inventory_key] = []

        slot_keys[bindable_slot.inventory_key].append(bindable_slot.slot_key)

func init_inventories(key: Inventory.InventoryKey, entity: Character):
    var inventory: DictionaryInventory = entity.inventories[key]
    if not inventory:
        inventory = DictionaryInventory.new(slot_keys[key])
        entity.inventories[key] = inventory

    for bindable_slot in get_tree().get_nodes_by_groupe("bindable_slots"):
        if not bindable_slot.inventory_key or bindable_slot.inventory_key != key:
            continue
        
        bindable_slot.slot = inventory.get(bindable_slot.slot_key)
    