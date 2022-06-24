extends MeshInstance3D
class_name BindableSlot

enum BindableSlotKey {
    CHEST_PLATE,
    AMULET,

    FACE,
    EYES,
    HELMET,

    SHOES,

    GLOVES,

    LEFT_HAND_WEAPON,
    RIGHT_HAND_WEAPON
}

@export var inventory_key: Inventory.InventoryKey
@export var slot_key: BindableSlotKey

func _init():
    add_group("bindable_slots")

var slot: Slot = null:
    set(_slot):
        if slot: slot.disconnect("stack_changed", _on_stack_changed)
        slot = _slot
        if slot: slot.connect("stack_changed", _on_stack_changed)

func _on_stack_changed():
    if not slot or slot.is_empty():
        mesh = null
    
    mesh = slot.stack.item.mesh