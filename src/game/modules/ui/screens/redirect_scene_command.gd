extends Command
class_name RedirectSceneCommand

var _from: PackedScene
var _to: PackedScene

func _init(from: Node, to: PackedScene):
	_from = load(from.scene_file_path)
	_to = to

func _change_scene(to: PackedScene):
	Launch.get_tree().change_scene_to_packed(to)


func execute() -> void:
	redo()

func undo() -> void:
	_change_scene(_from)

func redo() -> void:
	_change_scene(_to)
