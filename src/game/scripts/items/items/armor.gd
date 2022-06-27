extends Equipment
class_name Armor

func _init():
    equipment_category = Equipment.EquipmentCategory.ARMOR


enum ArmorCategory {
    HELMET,
    CHESTPLATE,
    GLOVES,
    SHOES,
    SHOULDER_PADS,
    RING
}

@export var name: String = ""
@export var armor_category: ArmorCategory