extends Node

var player_template = preload("res://scenes/player/player_template.tscn")

func spawn_other_player(other_player_id: int, other_player_state: Dictionary) -> void:
	var new_other_player = player_template.instantiate()
	new_other_player.init(other_player_id, other_player_state["P"])
	add_child(new_other_player)

func despawn_other_player(other_player_id: int) -> void:
	if has_node(str(other_player_id)):
		get_node(str(other_player_id)).queue_free()

func update_other_player(other_player_id: int, other_player_state: Dictionary):
	if has_node(str(other_player_id)):
		var other_player = get_node(str(other_player_id))
		other_player.set_position(other_player_state["P"])

func has_other_player(other_player_id: int) -> bool:
	return has_node(str(other_player_id))

func get_other_player(other_player_id) -> Node3D:
	return get_node(str(other_player_id))
