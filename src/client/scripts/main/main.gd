extends Node

@onready 
var _light = $DirectionalLight3D
@onready 
var _terrain = $VoxelTerrain
@onready
var _entities = $Entities

var fireball_collection = {}

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
		_entities._players.spawn_entity(player_id, {
			"P": spawn_position
		})

func despawn_player(player_id: int) -> void:
	await get_tree().create_timer(.2).timeout
	_entities._players.despawn_entity(player_id)
	
func _physics_process(_delta: float) -> void:
	handle_world_buffer()
	handle_fireball()

func handle_world_buffer():
	var render_time = Server.client_clock - interpolation_offset
	
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2].T:
			world_state_buffer.remove_at(0)
		
		# Interpolation
		if world_state_buffer.size() > 2:
			var interpolation_factor = float(render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[1]["T"])
			
			# Update Entities via the managers
			for entity_type in world_state_buffer[2]["E"].keys():
				var entities_manager: EntitiesManager = _entities.get_entities_manager(entity_type)
				if not entities_manager: continue
				
				for entity_id in world_state_buffer[2]["E"][entity_type].keys():
					if entity_id == get_tree().multiplayer.get_unique_id():
						continue
					var entities_next_state: Dictionary = world_state_buffer[2]["E"][entity_type][entity_id]
					if not world_state_buffer[1]["E"][entity_type].has(entity_id):
						continue
					var entities_last_state: Dictionary = world_state_buffer[1]["E"][entity_type][entity_id]
					
					if entities_manager.has_entity(entity_id):
						var duplicate_state: Dictionary = entities_next_state.duplicate(true)
						duplicate_state["P"] = entities_last_state["P"].lerp(entities_next_state["P"], interpolation_factor)
						duplicate_state["R"] = entities_last_state["R"].lerp(entities_next_state["R"], interpolation_factor)
						entities_manager.get_entity(entity_id).set_state(duplicate_state)
#					else:
#						entities_manager.spawn_entity(entity_id, entities_next_state)
		# Extrapolation
		elif render_time > world_state_buffer[1].T:
			var extrapolation_factor = float(render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.0
			
			# Update Entities via the managers
			for entity_type in world_state_buffer[1]["E"].keys():
				var entities_manager: EntitiesManager = _entities.get_entities_manager(entity_type)
				if not entities_manager: continue
				
				for entity_id in world_state_buffer[1]["E"][entity_type].keys():
					if entity_id == get_tree().multiplayer.get_unique_id():
						continue
					var entities_next_state: Dictionary = world_state_buffer[1]["E"][entity_type][entity_id]
					if not world_state_buffer[0]["E"][entity_type].has(entity_id):
						continue
					var entities_last_state: Dictionary = world_state_buffer[0]["E"][entity_type][entity_id]
					
					if entities_manager.has_entity(entity_id):
						var duplicate_state: Dictionary = entities_next_state.duplicate(true)
						var position_delta = (duplicate_state["P"] - entities_last_state["P"])
						var rotation_delta = (duplicate_state["R"] - entities_last_state["R"])
						
						duplicate_state["P"] += position_delta * extrapolation_factor
						duplicate_state["R"] += rotation_delta * extrapolation_factor
						entities_manager.get_entity(entity_id).set_state(duplicate_state)

func update_world_state(world_state: Dictionary) -> void:
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state_buffer.append(world_state)

func sync_world_properties(world_properties: Dictionary):
	for entity_type in world_properties["E"].keys():
		var entities_manager: EntitiesManager = _entities.get_entities_manager(entity_type)
		if not entities_manager: continue
		
		for entity_id in world_properties["E"][entity_type].keys():
			entities_manager.update_or_spawn_entity_with_properties(entity_id, world_properties["E"][entity_type][entity_id])

func handle_fireball():
	for launch_time in fireball_collection.keys():
		if launch_time <= Server.client_clock:
			var fireball = fireball_collection[launch_time]
			
			if _entities._players.has_entity(fireball['player_id']):
				var character: Character = _entities._players.get_entity(fireball['player_id'])
				character._spells_manager.cast_fireball(fireball['direction'])
			
			fireball_collection.erase(launch_time)

func sync_fireball(direction: Vector3, player_id: int, spawn_time: int) -> void:
	fireball_collection[spawn_time] = {
		"player_id": player_id,
		"direction": direction
	}

func sync_chunk(data_array: PackedByteArray, size: int, voxels_position: Vector3i) -> void:
	# _terrain.sync_chunk(data_array, size, voxels_position)
	pass
