extends Node
class_name SaveManager

const ROOT_PATH := "res://save/"
var folder_path := ""
var full_path := ""

func set_save_path(save_identifier: String):
	full_path = folder_path + save_identifier + "/"
	var directory := Directory.new()

	if not directory.dir_exists(full_path):
		directory.open(folder_path)
		directory.make_dir(full_path)

func reset_save_path():
	full_path = ""

func is_ready() -> bool:
	return full_path != ""

static func generate_identifier() -> String:
	return str(6074)
	# return str(randi_range(0, 9999))
