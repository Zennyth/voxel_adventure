class_name VarReader
extends RefCounted
# Var file reader



## Public Methods
# Reads var file, returns it's Variant content
static func read(var_file : FileAccess ) -> Dictionary:
	var result := {
		"error": OK,
		"variant": var_file.get_var(),
	}
	
	return result


static func read_file(var_path : String) -> Dictionary:
	var result := { "error": OK }
	var var_file := FileAccess .new()
	result["error"] = var_file.open(var_path, FileAccess .READ)
	if result["error"] == OK:
		result = read(var_file)
	if var_file.is_open():
		var_file.close()
	return result
