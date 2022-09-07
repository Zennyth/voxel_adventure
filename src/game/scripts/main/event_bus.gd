extends Node


signal _world_ready(entity_manager: EntityManager)
signal _terrain_ready(terrain: VoxelTerrain)
signal _player_initialized

signal _debug_property_updated(key: DebugProperty.DebugPropertyKey, value)