extends CarouselButton
class_name RaceCarouselButton

signal _race_changed(new_race: Race)

var race: Race = null:
	set(_race):
		race = _race
		_race_changed.emit(race)

func _init():
	_index_changed.connect(_on_index_changed)
	list = Database.races.get_all()

func _on_index_changed(_index: int):
	race = list[index]

func init():
	if len(list) > 0:
		race = list[0]
