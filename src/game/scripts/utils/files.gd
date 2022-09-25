class_name FilesUtils

static func get_files_from_folder(rootPath: String):
	var files = []
	var directories = []
	var dir = DirAccess.open(rootPath)

	if dir != null:
		dir.list_dir_begin()
		_add_dir_contents(dir, files, directories)
	else:
		push_error("An error occurred when trying to access the path.")

	return files


static func _add_dir_contents(dir: DirAccess, files: Array, directories: Array):
	var file_name = dir.get_next()
	
	while (file_name != ""):
		var path = dir.get_current_dir() + "/" + file_name
		
		if dir.current_is_dir():
			var subDir = DirAccess.open(path)
			subDir.list_dir_begin()
			directories.append(path)
			_add_dir_contents(subDir, files, directories)
		
		else:
			files.append(path)

		file_name = dir.get_next()

	dir.list_dir_end()


static func get_folders(root_path: String) -> Array:
	var folders := []
	var dir = DirAccess.open(root_path)
	
	if dir != null:
		dir.list_dir_begin()
		var folder_name = dir.get_next()
		
		while (folder_name != ""):
			folders.append(folder_name)
			folder_name = dir.get_next()
		
	else:
		push_error("An error occurred when trying to access the path.")
	
	return folders
