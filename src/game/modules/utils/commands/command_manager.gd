extends RefCounted
class_name CommandManager

signal _command_executed(command: Command)

var _undo_stack: Array[Command] = []
var _redo_stack: Array[Command] = []

var has_undo: bool:
	get:
		return len(_undo_stack) > 0

var has_redo: bool:
	get:
		return len(_redo_stack) > 0

func execute(cmd: Command) -> void:
	_redo_stack = []
	cmd.execute()
	_undo_stack.insert(0, cmd)
	
	_command_executed.emit(cmd)

func undo() -> void:
	if !has_undo:
		return
	
	var cmd: Command = _undo_stack.pop_front()
	cmd.undo()
	_redo_stack.insert(0, cmd)
	
	_command_executed.emit(cmd)

func redo() -> void:
	if !has_redo:
		return
	
	var cmd: Command = _redo_stack.pop_front()
	cmd.redo()
	_undo_stack.insert(0, cmd)
	
	_command_executed.emit(cmd)
