extends ResourceDatabase

var _races: Dictionary = {}

func init():
	for file in FilesUtils.get_files_from_folder(PATH + "races/"):
		var race: Race = load(file)
		_races[race.name] = race
		race.init()


func get_by_name(race_name: String) -> Race:
	if not race_name in _races:
		return null
	
	return _races[race_name]


func get_all() -> Array:
	return _races.values()
