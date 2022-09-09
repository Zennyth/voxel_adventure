extends Reference
class_name ConnectionStrategyFactory

###
# STATIC
###
static func get_by_arguments() -> ConnectionStrategy:
	var arguments := CommandLineArguments.get_arguments()

	if CommandLineArguments.SERVER in arguments:
		return ServerConnectionStrategy.new()
	
	if CommandLineArguments.JOIN_GAME in arguments:
		return ClientConnectionStrategy.new()
	
	return null