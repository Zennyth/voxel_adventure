extends Button
class_name CustomLinkButton

signal _to_changed

var command_manager: CommandManager = Launch.screen_command_manager

@export var to: PackedScene:
	set(value):
		to = value
		_to_changed.emit(to)

func _init():
	button_down.connect(_on_button_pressed)
	_to_changed.connect(_on_to_changed)
	disabled = to == null

func _on_button_pressed():
	command_manager.execute(RedirectSceneCommand.new(get_owner(), to))

func _on_to_changed(_to: PackedScene):
	disabled = to == null
