extends Node
class_name SaveManager

const ROOT_PATH := "res://save"
var folder_path := ""
var full_path := ""

func set_save_path(save_identifier: int):
	full_path = ROOT_PATH + folder_path + str(save_identifier) + "/"

func reset_save_path():
	full_path = ""

func is_ready() -> bool:
	return full_path != ""

static func generate_identifier() -> int:
	return randi_range(0, 9999)
