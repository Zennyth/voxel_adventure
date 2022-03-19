extends Node

#onready var _light = $DirectionalLight
#onready var _terrain = $VoxelTerrain

var player_template = preload("res://scenes/player/player_template.tscn")

var last_world_state = 0
var world_state_buffer = []
const interpolation_offset = 100

func _unhandled_input(event):
	pass
	# TODO Make a pause menu with options?
#	if event is InputEventKey:
#		if event.pressed:
#			if event.scancode == KEY_L:
#				# Toggle shadows
#				_light.shadow_enabled = not _light.shadow_enabled


func _notification(what: int):
	pass
#	match what:
#		NOTIFICATION_WM_QUIT_REQUEST:
#			# Save game when the user closes the window
#			_save_world()


func _save_world():
	# _terrain.save_modified_blocks()
	pass

func spawn_player(player_id, spawn_position):
	if get_tree().multiplayer.get_unique_id() == player_id:
		pass
	else:
		var new_player = player_template.instantiate()
		new_player.name = str(player_id)
		new_player.position = spawn_position
		get_node("entities/otherPlayers").add_child(new_player)

func despawn_player(player_id):
	await get_tree().create_timer(.2)
	get_node("entities/otherPlayers" + str(player_id)).queue_free()
	
func _physics_process(_delta):
	var render_time = server.client_clock - interpolation_offset
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

				if get_node("entities/otherPlayers").has_node(str(player)):
					#print(world_state_buffer[1]["players"][player]["P"], world_state_buffer[2]["players"][player]["P"], interpolation_factor)
					var new_position = world_state_buffer[1]["players"][player]["P"].lerp(world_state_buffer[2]["players"][player]["P"], interpolation_factor)
					get_node("entities/otherPlayers/" + str(player)).position = new_position
				else:
					spawn_player(player, world_state_buffer[2]["players"][player]["P"])

		elif render_time > world_state_buffer[1].T:
			var extrapolation_factor = float(render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.0

			for player in world_state_buffer[1]["players"].keys():
				if player == get_tree().multiplayer.get_unique_id():
					continue
				if not world_state_buffer[0]["players"].has(player):
					continue

				if get_node("entities/otherPlayers").has_node(str(player)):
					var position_delta = (world_state_buffer[1]["players"][player]["P"] - world_state_buffer[0]["players"][player]["P"])
					var new_position = world_state_buffer[1]["players"][player]["P"] + (position_delta * extrapolation_factor)
					get_node("entities/otherPlayers/" + str(player)).position = new_position


func update_world_state(world_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state_buffer.append(world_state)
		
#		world_state["players"].erase(get_tree().multiplayer.get_unique_id())
#		for player in world_state["players"].keys():
#			if get_node("entities/otherPlayers").has_node(str(player)):
#				get_node("entities/otherPlayers/" + str(player)).position = world_state["players"][player]["P"]
#			else:
#				spawn_player(player, world_state["players"][player]["P"])

func sync_fireball(direction, player_id):
	if get_node("entities/otherPlayers").has_node(str(player_id)):
		get_node("entities/otherPlayers/" + str(player_id)).get_node("spells").cast_fireball(direction)

func sync_chunk(buffer: StreamPeerBuffer, size: int, voxels_position: Vector3i):
	get_node("VoxelTerrain").sync_chunk(buffer, size, voxels_position)
