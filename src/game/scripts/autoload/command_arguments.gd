extends Node
# class_name CommandLineArguments

const _SEPARATORS 			:= ["--", "+"]

const MAX_PLAYERS 			= "max_players"

const SERVER 				= "server"
const JOIN_GAME 			= "connect_lobby"
const HOST 					= "host"

const ENET 					= "enet"
const ENET_IP 				= "ip"
const ENET_PORT 			= "port"

const STEAM_CONNECT_LOBBY 	= "connect_lobby"
const STEAM_LOBBY_TYPE		= "lobby_type"


func get_arguments() -> Dictionary:
	return _arguments

var _arguments: Dictionary = {}

func _init():
	_parse_arguments()

func _parse_arguments():
	var arguments := OS.get_cmdline_args()
	
	for i in len(arguments):
		var argument = arguments[i]
		var separator = _find_separator(argument)
		
		if separator == null:
			continue
			
		var key := argument.lstrip(separator)
		
		if len(arguments) > i + 1 and _find_separator(arguments[i+1]) == null:
			_arguments[key] = arguments[i+1]
		else:
			_arguments[key] = true
	
	if MAX_PLAYERS not in _arguments:
		_arguments[MAX_PLAYERS] = 4


func _find_separator(text: String):
	for separator in _SEPARATORS:
		if text.find(separator) >= 0:
			return separator
	
	return null
