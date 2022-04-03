extends CharacterBody3D

@export var _character_path: NodePath
var _character: Character

func _ready():
	_character = get_node(_character_path)
