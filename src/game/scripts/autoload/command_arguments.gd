extends Reference
# class_name CommandLineArguments

CONST MAX_PLAYERS = "max_players"

const SERVER = "server"
const JOIN_GAME = "join"

const ENET = "enet"
const ENET_IP = "port"
const ENET_PORT = "ip"

const STEAM = "steam"
const STEAM_LOBBY_ID = "lobby_id"
const STEAM_LOBBY_TYPE = "lobby_type"


func get_arguments() -> Dictionary:
	return _arguments

var _arguments: Dictionary = {}

const _SEPARATOR = "--"
const _DEFINITION = "="

func _init():
	_parse_arguments()

func _parse_arguments():
	for argument in OS.get_cmdline_args():
		if argument.find(_DEFINITION) < 0:
			continue
		
		var key_value = argument.split(_DEFINITION)
		arguments[key_value[0].lstrip(_SEPARATOR)] = key_value[1]