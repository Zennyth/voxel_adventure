extends Controller
class_name PlayerController


###
# BUILT-IN
###
@export var player_path: NodePath
@onready var player: Player = get_node(player_path)


###
# OVERRIDE
###
func get_direction() -> Vector3:
	var input_dir := Input.get_vector("controls_left", "controls_right", "controls_forward", "controls_backward")
	if input_dir.length_squared() > 1.0: input_dir = input_dir.normalized()
	
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	direction = direction.rotated(Vector3.UP, player.springArmPlayer.rotation.y)
	
	return direction

func get_controllable() -> Character:
	return player as Character

func is_jumping() -> bool:
	return Input.is_action_just_pressed("ui_accept")

func _ready():
	set_slot_active(Travel.get_key(Travel.TravelCategory.HANG_GLIDING), false)
	set_slot_active(Weapon.get_key(Weapon.SlotCategory.LEFT_HAND), true)
	set_slot_active(Weapon.get_key(Weapon.SlotCategory.RIGHT_HAND), true)
###
# BUILT-IN
# Equipments
###
func _input(event: InputEvent) -> void:
	if not event:
		return
	
	if Input.is_action_just_pressed("ui_traveling"):
		var is_slot_active = get_is_slot_active(Travel.get_key(Travel.TravelCategory.HANG_GLIDING))
		
		set_slot_active(Travel.get_key(Travel.TravelCategory.HANG_GLIDING), !is_slot_active)
		set_slot_active(Weapon.get_key(Weapon.SlotCategory.LEFT_HAND), is_slot_active)
		set_slot_active(Weapon.get_key(Weapon.SlotCategory.RIGHT_HAND), is_slot_active)


###
# UTILS
###
const inventory_key := Inventory.InventoryCategory.CHARACTER_EQUIPMENTS

func get_is_slot_active(equipment_key: String) -> bool:
	var slot: Slot = player.data.get_slot(inventory_key, equipment_key)
	if not slot:
		return false
	
	return slot.is_active

func set_slot_active(equipment_key: String, is_now_active = null):
	var slot: Slot = player.data.get_slot(inventory_key, equipment_key)
	if not slot:
		return
	slot.is_active = is_now_active if (is_now_active != null and is_now_active is bool) else !slot.is_active
