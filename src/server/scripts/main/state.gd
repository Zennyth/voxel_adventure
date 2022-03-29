extends Node

var world_state: Dictionary = {}

func _physics_process(_delta: float) -> void:
	if get_parent().player_state_collection.keys().size() > 0:
		world_state = {
			"T": Time.get_ticks_msec(),
			"players": get_parent().player_state_collection.duplicate(true),
			"Enemies": get_node("../Enemies").enemy_list
		}
		
		#print(world_state)
		for player in world_state["players"].keys():
			world_state["players"][player].erase("T")
		
		# further processing
		get_parent().send_world_state(world_state)
