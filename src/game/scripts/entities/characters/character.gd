extends Entity
class_name Character


###
# LOGIC
# GAME
###
var data: DataManager = null:
	set(_data_manager):
		if data: 
			data._character_class_update.disconnect(update_cosmetics_by_class)
		data = _data_manager
		if data: 
			data._character_class_update.connect(update_cosmetics_by_class)

func update_cosmetics_by_class(new_class: Class):
	var inventory_key := Inventory.InventoryCategory.CHARACTER_COSMETIC
	data.set_new_stack(inventory_key, Cosmetic.get_key(Cosmetic.CosmeticCategory.CHEST), new_class.default_chest)
	data.set_new_stack(inventory_key, Cosmetic.get_key(Cosmetic.CosmeticCategory.FEET), new_class.default_feet)

func randomize_cosmetics():
	var inventory := data.get_inventory(Inventory.InventoryCategory.CHARACTER_COSMETIC)

	for slot in inventory.get_slots():
		var item: Cosmetic = RandomUtils.get_random_from_array(data.character_race.dictionary_cosmetics[slot.id])
		slot.set_stack(Stack.new(item, 1))


###
# BUILT-IN
# Character3D and movements
###
var character: CharacterBody3D

var sync_position: SyncProperty
func _position_synced(new_position):
	if not is_authoritative():
		character.position = new_position

var sync_rotation: SyncProperty
func _rotation_synced(new_rotation):
	if not is_authoritative():
		character.Body.rotation = new_rotation

func _init():
	character = $"." as CharacterBody3D

func _ready():
	sync_position = SyncProperty.new(character.position, WorldState.STATE_KEYS.POSITION, self, null, null, false)
	sync_position._property_changed.connect(_position_synced)
	sync_rotation = SyncProperty.new(character.Body.rotation, WorldState.STATE_KEYS.ROTATION, self, null, null, false)
	sync_rotation._property_changed.connect(_rotation_synced)

@export var default_speed := 10.0
@export var JUMP_VELOCITY := 8.0
# Get the gravity from the project settings to be synced with CharacterBody3D nodes.
var default_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func jump():
	if character.is_on_floor():
		character.velocity.y = JUMP_VELOCITY

func move(direction, delta: float, gravity: float = -1.0, speed: float = -1.0):
	if gravity == -1.0:
		gravity = default_gravity
	if speed == -1.0:
		speed = default_speed
	
	if not character.is_on_floor():
		character.velocity.y -= gravity * delta

	if direction:
		character.velocity.x = direction.x * speed
		character.velocity.z = direction.z * speed
		
		var look_direction = atan2(- direction.x, direction.z)
		if look_direction != 0:
			character.Body.rotation.y = lerp_angle(character.Body.rotation.y, - look_direction, delta * 9.8)
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, speed)
		character.velocity.z = move_toward(character.velocity.z, 0, speed)
		
	update()

func update():
	if is_authoritative(): 
		character.move_and_slide()
		sync_position.set_property(character.position)
		sync_rotation.set_property(character.Body.rotation)
		update_unstable_state()
