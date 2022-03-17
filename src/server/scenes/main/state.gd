extends Node

var world_state


func _physics_process(_delta):
	if not get_parent().player_state_collection.empty():
		world_state = {
			"T": OS.get_system_time_msecs(),
			"players": get_parent().player_state_collection.duplicate(true)
		}
		
		for player in world_state["players"].keys():
			world_state["players"][player].erase("T")
		
		# further processing
		
		get_parent().send_world_state(world_state)
