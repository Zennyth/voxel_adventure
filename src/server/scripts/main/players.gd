extends Node3D

var player_template = preload("res://scenes/player/player.tscn")

func spawn_player(player_id: int, player_state: Dictionary) -> void:
	var new_player = player_template.instantiate()
	new_player.init(player_id, player_state["P"])
	add_child(new_player)

func despawn_player(player_id: int) -> void:
	if has_node(str(player_id)):
		get_node(str(player_id)).queue_free()

func update_player(player_id: int, player_state: Dictionary) -> void:
	if has_node(str(player_id)):
		var player = get_node(str(player_id))
		player.set_position(player_state["P"])
