extends Network
class_name ENetNetwork

###
# OVERRIDE
###
func _init():
	network = ENetMultiplayerPeer.new()

func create_client(args: Dictionary):
	network.create_client(args[CommandLineArguments.ENET_IP], args[CommandLineArguments.ENET_PORT])
	super.create_client(args)

func create_server(args: Dictionary):
	network.create_server(args[CommandLineArguments.ENET_PORT], args[CommandLineArguments.MAX_PLAYERS])
	super.create_server(args)
