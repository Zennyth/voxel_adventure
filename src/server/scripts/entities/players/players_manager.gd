extends EntitiesManager

####
## State
####

func receive_player_state(player_id: int, player_state: Dictionary) -> void:
	if entity_state_collection.has(player_id):
		if entity_state_collection[player_id]["T"] < player_state["T"]:
			entity_state_collection[player_id] = player_state
	else:
		# new player has connect
		entity_state_collection[player_id] = player_state
		# spawn_entity(player_id).set_state(player_state)

func get_entity_state_collection() -> Dictionary:
	var entity_state_collection_clone: Dictionary = entity_state_collection.duplicate(true)
	for player in entity_state_collection_clone.keys():
		entity_state_collection_clone[player].erase("T")
		
	for player_id in entity_state_collection_clone.keys():
		update_entity_state(player_id, entity_state_collection_clone[player_id])
		
	return entity_state_collection_clone

####
## Properties
####

func receive_player_properties(player_id: int, player_properties: Dictionary) -> void:
	entity_properties_collection[player_id] = player_properties
	spawn_entity(player_id).set_properties(player_properties)

####
## Main
####

func despawn_player(player_id: int):
	if entity_state_collection.has(player_id): 
		entity_state_collection.erase(player_id)
	despawn_entity(player_id)

func destroy_entity(_entity_id: int):
	pass
