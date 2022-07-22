extends Reference
class_name ConnectionStrategyFactory

###
# STATIC
###
static func get_strategy() -> ConnectionStrategy:
	if "--server" in OS.get_cmdline_args():
		return ServerConnectionStrategy.new()
	else:
		return ClientConnectionStrategy.new()
	
	return SoloConnectionStrategy.new()
