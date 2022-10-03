extends Network
class_name SteamNetwork

###
# OVERRIDE
###
func _init():
	network = SteamNetworkPeer.new()
	Steam.lobby_created.connect(_lobby_created)

func create_client(args: Dictionary):
	network.create_client(args[CommandLineArguments.STEAM_CONNECT_LOBBY].to_int())
	super.create_client(args)

func create_server(args: Dictionary):
	network.create_server(args[CommandLineArguments.STEAM_LOBBY_TYPE], args[CommandLineArguments.MAX_PLAYERS])
	super.create_server(args)


###
# BUILT-IN
# Steam
###
func _ready():
	_initialize_steam()

func _process(_delta: float) -> void:
	Steam.run_callbacks()

func _initialize_steam() -> void:
	var init: Dictionary = Steam.steamInit()
	print("Did Steam initialize?: "+str(init))

	if init['status'] != 1:
		print("Failed to initialize Steam. "+str(init['verbal'])+" Shutting down...")
		get_tree().quit()

func _lobby_created(_connect_id: int, lobby_id: int):
	_connection_succeeded.emit()
	print_debug(lobby_id)
