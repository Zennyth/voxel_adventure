extends WorldState
class_name UnstableWorldStateBuffer

###
# BUILT-IN
###
var last_world_state_timestamp = 0
var world_state_buffer = []
const interpolation_offset = 50

func _physics_process(_delta: float) -> void:
	handle_world_state_buffer()

func handle_world_state_buffer():
	var render_time = clock_synchronizer.client_clock - interpolation_offset

	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2][STATE_KEYS.TIME]:
			world_state_buffer.remove_at(0)

		# Interpolation
		if world_state_buffer.size() > 2:
			var interpolation_factor = float(render_time - world_state_buffer[1][STATE_KEYS.TIME]) / float(world_state_buffer[2][STATE_KEYS.TIME] - world_state_buffer[1][STATE_KEYS.TIME])

			# Update Entities via the managers
			for entity_id in world_state_buffer[2][STATE_KEYS.ENTITIES].keys():
#				if Multiplayer.is_entity_authoritative(entity_id):
#					continue
				var entities_next_state: Dictionary = world_state_buffer[2][STATE_KEYS.ENTITIES][entity_id]
				if not world_state_buffer[1][STATE_KEYS.ENTITIES].has(entity_id):
					continue
				var entities_last_state: Dictionary = world_state_buffer[1][STATE_KEYS.ENTITIES][entity_id]

				var duplicate_state: Dictionary = entities_next_state.duplicate(true)
				duplicate_state[STATE_KEYS.POSITION] = entities_last_state[STATE_KEYS.POSITION].lerp(entities_next_state[STATE_KEYS.POSITION], interpolation_factor)
				duplicate_state[STATE_KEYS.ROTATION] = entities_last_state[STATE_KEYS.ROTATION].lerp(entities_next_state[STATE_KEYS.ROTATION], interpolation_factor)
				entity_manager.update_entity_unstable_state(entity_id, duplicate_state)

		# Extrapolation
		elif render_time > world_state_buffer[1][STATE_KEYS.TIME]:
			var extrapolation_factor = float(render_time - world_state_buffer[0][STATE_KEYS.TIME]) / float(world_state_buffer[1][STATE_KEYS.TIME] - world_state_buffer[0][STATE_KEYS.TIME]) - 1.0

			# Update Entities via the managers
			for entity_id in world_state_buffer[1][STATE_KEYS.ENTITIES].keys():
#				if Multiplayer.is_entity_authoritative(entity_id):
#					continue
				var entities_next_state: Dictionary = world_state_buffer[1][STATE_KEYS.ENTITIES][entity_id]
				if not world_state_buffer[0][STATE_KEYS.ENTITIES].has(entity_id):
					continue
				var entities_last_state: Dictionary = world_state_buffer[0][STATE_KEYS.ENTITIES][entity_id]

				if entity_manager.has_entity(entity_id):
					var duplicate_state: Dictionary = entities_next_state.duplicate(true)
					var position_delta = (duplicate_state[STATE_KEYS.POSITION] - entities_last_state[STATE_KEYS.POSITION])
					var rotation_delta = (duplicate_state[STATE_KEYS.ROTATION] - entities_last_state[STATE_KEYS.ROTATION])

					duplicate_state[STATE_KEYS.POSITION] += position_delta * extrapolation_factor
					duplicate_state[STATE_KEYS.ROTATION] += rotation_delta * extrapolation_factor
					entity_manager.update_entity_unstable_state(entity_id, duplicate_state)

func update_world_state_buffer(world_state: Dictionary) -> void:
	if world_state[STATE_KEYS.TIME] > last_world_state_timestamp:
		last_world_state_timestamp = world_state[STATE_KEYS.TIME]
		world_state_buffer.append(world_state)
