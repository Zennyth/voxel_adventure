extends Node

@onready 
var _light = $DirectionalLight3D
@onready 
var _terrain = $VoxelTerrain
@onready
var _entities = $Entities

var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 100

func _unhandled_input(event: InputEvent) -> void:
	pass
	# TODO Make a pause menu with options?
#	if event is InputEventKey:
#		if event.pressed:
#			if event.scancode == KEY_L:
#				# Toggle shadows
#				_light.shadow_enabled = not _light.shadow_enabled


func _notification(what: int) -> void:
	pass
#	match what:
#		NOTIFICATION_WM_QUIT_REQUEST:
#			# Save game when the user closes the window
#			_save_world()


func _save_world() -> void:
	# _terrain.save_modified_blocks()
	pass

func spawn_player(player_id: int, spawn_position: Vector3) -> void:
	if get_tree().multiplayer.get_unique_id() == player_id:
		pass
	else:
		_entities._other_players.spawn_entity(player_id, {
			"P": spawn_position
		})

func despawn_player(player_id: int) -> void:
	await get_tree().create_timer(.2)
	_entities._other_players.despawn_entity(player_id)
	
func _physics_process(_delta: float) -> void:
	var render_time = Server.client_clock - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2].T:
			world_state_buffer.remove_at(0)

		if world_state_buffer.size() > 2:
			var interpolation_factor = float(render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])


			for player in world_state_buffer[2]["players"].keys():
				if player == get_tree().multiplayer.get_unique_id():
					continue
				if not world_state_buffer[1]["players"].has(player):
					continue

				if _entities._other_players.has_entity(player):
					#print(world_state_buffer[1]["players"][player]["P"], world_state_buffer[2]["players"][player]["P"], interpolation_factor)
					var new_position = world_state_buffer[1]["players"][player]["P"].lerp(world_state_buffer[2]["players"][player]["P"], interpolation_factor)
					_entities._other_players.get_entity(player).set_position(new_position)
				else:
					_entities._other_players.spawn_entity(player, world_state_buffer[2]["players"][player])

		elif render_time > world_state_buffer[1].T:
			var extrapolation_factor = float(render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.0

			for player in world_state_buffer[1]["players"].keys():
				if player == get_tree().multiplayer.get_unique_id():
					continue
				if not world_state_buffer[0]["players"].has(player):
					continue

				if _entities._other_players.has_entity(player):
					var position_delta = (world_state_buffer[1]["players"][player]["P"] - world_state_buffer[0]["players"][player]["P"])
					var new_position = world_state_buffer[1]["players"][player]["P"] + (position_delta * extrapolation_factor)
					_entities._other_players.get_entity(player).set_position(new_position)


func update_world_state(world_state: Dictionary) -> void:
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state_buffer.append(world_state)

func sync_fireball(direction: Vector3, player_id: int) -> void:
	if _entities._other_players.has_entity(player_id):
		var character: Character = _entities._other_players.get_entity(player_id)
		character.spells_manager.cast_fireball(direction)

func sync_chunk(data_array: PackedByteArray, size: int, voxels_position: Vector3i) -> void:
	_terrain.sync_chunk(data_array, size, voxels_position)
