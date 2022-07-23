extends EquipmentBindableSlot
class_name ArmorBindableSlot

@export var binded_cosmetic_slot_path: NodePath
@onready var binded_cosmetic_slot: CosmeticBindableSlot = get_node(binded_cosmetic_slot_path) if binded_cosmetic_slot_path else null

func slot_changed():
	super.slot_changed()
	
	if binded_cosmetic_slot and binded_cosmetic_slot.is_mesh_visible: 
		binded_cosmetic_slot.is_mesh_visible.set_property(mesh_instance.mesh == null)


@export var armor_key: Armor.ArmorCategory:
	set(_armor_key):
		armor_key = _armor_key
		update_key()

func _init():
	equipement_key = Equipment.EquipmentCategory.ARMOR
	update_key()
	super._init()

func update_key():
	slot_key = Armor.get_key(armor_key)
	super.update_key()

