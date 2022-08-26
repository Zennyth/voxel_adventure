extends Network
class_name ENetNetwork

###
# OVERRIDE
###
func _init():
	network = ENetMultiplayerPeer.new()

func create_client(args: Dictionary):
	network.create_client(args['ip'], args['port'])
	super.create_client(args)

func create_server(args: Dictionary):
	network.create_server(args['port'], args['MAX_PLAYERS'])
	super.create_server(args)
