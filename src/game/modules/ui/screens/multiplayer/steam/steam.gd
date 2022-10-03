extends SequenceMenu

@export var world: PackedScene
var network := SteamNetwork.new()
@onready var join_lobby_input: TextEdit = $VBoxContainer/VBoxContainer/JoinLobbyInput

func _on_create_lobby_pressed():
	var connection_strategy := HostConnectionStrategy.new()
	Game.multiplayer_manager.set_connection(
		connection_strategy, 
		network, 
		{
			CommandLineArguments.STEAM_LOBBY_TYPE: 1,
			CommandLineArguments.MAX_PLAYERS: 4
		}
	)
	next_screen(world)

func _on_join_lobby_pressed():
	var connection_strategy := ClientConnectionStrategy.new()
	Game.multiplayer_manager.set_connection(
		connection_strategy, 
		network,
		{
			CommandLineArguments.JOIN_GAME: join_lobby_input.text,
		}
	)
	next_screen(world)
