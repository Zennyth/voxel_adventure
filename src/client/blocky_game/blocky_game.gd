extends Node

onready var _light = $DirectionalLight
onready var _terrain = $VoxelTerrain

var player_template = preload("res://blocky_game/player/player_template.tscn")


func _unhandled_input(event):
	# TODO Make a pause menu with options?
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_L:
				# Toggle shadows
				_light.shadow_enabled = not _light.shadow_enabled


func _notification(what: int):
	match what:
		NOTIFICATION_WM_QUIT_REQUEST:
			# Save game when the user closes the window
			_save_world()


func _save_world():
	# _terrain.save_modified_blocks()
	pass

func spawn_player(player_id, spawn_position):
	if get_tree().get_network_unique_id() == player_id:
		pass
	else:
		var new_player = player_template.instance()
		new_player.name = str(player_id)
		new_player.translation = spawn_position
		get_node("entities/otherPlayers").add_child(new_player)

func despawn_player(player_id):
	get_node("entities/otherPlayers" + str(player_id)).queue_free()
