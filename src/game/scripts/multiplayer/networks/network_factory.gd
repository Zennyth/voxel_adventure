extends Reference
class_name NetworkFactory

###
# STATIC
###
static func get_by_arguments() -> Network:
  var arguments := CommandLineArguments.get_arguments()

	if CommandLineArguments.ENET in arguments:
		return ENetNetwork.new()
	
	if CommandLineArguments.STEAM in arguments:
		return SteamNetwork.new()
	
	return null