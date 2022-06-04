extends Node
class_name WorldStateBuffer

###
# BUILT-IN
###
var last_world_state_timestamp = 0
var world_state_buffer = []
const interpolation_offset = 100
var entity_manager: EntityManager
const ClockSynchronizer = preload("res://scripts/multiplayer/connection_strategies/client/clock_synchronizer.gd")
var clock_synchronizer: ClockSynchronizer

func init(manager: EntityManager, clock: ClockSynchronizer):
	entity_manager = manager
	clock_synchronizer = clock

func _physics_process(_delta: float) -> void:
	handle_world_state_buffer()

func handle_world_state_buffer():
	var render_time = clock_synchronizer.client_clock - interpolation_offset

	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2]['t']:
			world_state_buffer.remove_at(0)

		# Interpolation
		if world_state_buffer.size() > 2:
			var interpolation_factor = float(render_time - world_state_buffer[1]['t']) / float(world_state_buffer[2]['t'] - world_state_buffer[1]['t'])

			# Update Entities via the managers
			for entity_id in world_state_buffer[2]['e'].keys():
				if Multiplayer.is_entity_authoritative(entity_id):
					continue
				var entities_next_state: Dictionary = world_state_buffer[2]['e'][entity_id]
				if not world_state_buffer[1]['e'].has(entity_id):
					continue
				var entities_last_state: Dictionary = world_state_buffer[1]['e'][entity_id]
				

				if not entity_manager.has_entity(entity_id):
					entity_manager.spawn_player(entity_id)

				var duplicate_state: Dictionary = entities_next_state.duplicate(true)
				duplicate_state['p'] = entities_last_state['p'].lerp(entities_next_state['p'], interpolation_factor)
				duplicate_state['r'] = entities_last_state['r'].lerp(entities_next_state['r'], interpolation_factor)
				entity_manager.update_entity_state(entity_id, duplicate_state)

		# Extrapolation
		elif render_time > world_state_buffer[1]['t']:
			var extrapolation_factor = float(render_time - world_state_buffer[0]['t']) / float(world_state_buffer[1]['t'] - world_state_buffer[0]['t']) - 1.0

			# Update Entities via the managers
			for entity_id in world_state_buffer[1]['e'].keys():
				if Multiplayer.is_entity_authoritative(entity_id):
					continue
				var entities_next_state: Dictionary = world_state_buffer[1]['e'][entity_id]
				if not world_state_buffer[0]['e'].has(entity_id):
					continue
				var entities_last_state: Dictionary = world_state_buffer[0]['e'][entity_id]

				if entity_manager.has_entity(entity_id):
					var duplicate_state: Dictionary = entities_next_state.duplicate(true)
					var position_delta = (duplicate_state['p'] - entities_last_state['p'])
					var rotation_delta = (duplicate_state['r'] - entities_last_state['r'])

					duplicate_state['p'] += position_delta * extrapolation_factor
					duplicate_state['r'] += rotation_delta * extrapolation_factor
					entity_manager.update_entity_state(entity_id, duplicate_state)

func update_world_state_buffer(world_state: Dictionary) -> void:
	if world_state['t'] > last_world_state_timestamp:
		last_world_state_timestamp = world_state['t']
		world_state_buffer.append(world_state)
