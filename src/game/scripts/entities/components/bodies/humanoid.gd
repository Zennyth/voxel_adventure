extends Body
class_name HumanoidBody

var humanoid: Humanoid
	
func _ready():
	if not entity is Humanoid:
		print("Entity: ", entity, " is not a Humanoid !")

    bindable_slot_manager.init_inventory(Inventory.InventoryKey.COSMETIC_INVENTORY, entity)
    bindable_slot_manager.init_inventory(Inventory.InventoryKey.EQUIPMENT_INVENTORY, entity)

func get_stable_state(state: Dictionary = { }, component: Node = self) -> Dictionary:
	return super.get_stable_state(state, component)

func set_stable_state(new_state: Dictionary, component: Node = self) -> void:
	super.set_stable_state(new_state, component)
