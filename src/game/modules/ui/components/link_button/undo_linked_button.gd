extends Button

var command_manager: CommandManager = Launch.screen_command_manager

func _init():
	button_down.connect(_on_button_pressed)
	command_manager._command_executed.connect(_on_command_executed)

func _on_button_pressed():
	command_manager.undo()

func _on_command_executed(cmd: Command):
	visible = command_manager.has_undo
