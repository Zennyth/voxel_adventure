extends EquipmentBindableSlot
class_name ArmorBindableSlot

@export var binded_cosmetic_slot_path: NodePath
@onready var binded_cosmetic_slot: CosmeticBindableSlot = get_node(binded_cosmetic_slot_path)

func update_slot():
	super.update_slot()
	if binded_cosmetic_slot: 
		binded_cosmetic_slot.visible(part.mesh == null)


@export var armor_key: Armor.ArmorCategory:
	set(_armor_key):
		armor_key = _armor_key
		update_key()

func _init():
	equipement_key = Equipment.EquipmentCategory.ARMOR
	update_key()
	super._init()

func update_key():
	update_slot_key(str(armor_key))

