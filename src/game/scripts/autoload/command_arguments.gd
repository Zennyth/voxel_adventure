extends Node
# class_name CommandLineArguments

const MAX_PLAYERS = "max_players"

const SERVER = "server"
const JOIN_GAME = "join"

const ENET = "enet"
const ENET_IP = "ip"
const ENET_PORT = "port"

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
	var arguments := OS.get_cmdline_args()
	
	for i in len(arguments):
		var argument = arguments[i]
		
		if argument == "+connect_lobby":
			_arguments[JOIN_GAME] = arguments[i+1].to_int()
		
		if argument.find(_DEFINITION) < 0:
			continue
		
		var key_value = argument.split(_DEFINITION)
		_arguments[key_value[0].lstrip(_SEPARATOR)] = key_value[1]
