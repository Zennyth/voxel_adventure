extends Control

var network := SteamNetwork.new()



@onready var join_lobby_input: TextEdit = $VBoxContainer/VBoxContainer/JoinLobbyInput

func _on_create_lobby_pressed():
	var connection_strategy := HostConnectionStrategy.new()
	Game.multiplayer_manager.set_connection(
		connection_strategy, 
		network, 
		{
			'lobby_type': 1,
			'MAX_PLAYERS': 4
		}
	)
	get_tree().change_scene("res://scenes/terrain/test.tscn")

func _on_join_lobby_pressed():
	var connection_strategy := ClientConnectionStrategy.new()
	Game.multiplayer_manager.set_connection(
		connection_strategy, 
		network,
		{
			'lobby_id': join_lobby_input.text.to_int(),
		}
	)
	get_tree().change_scene("res://scenes/terrain/test.tscn")
