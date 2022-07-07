extends CarouselButton
class_name ClassCarouselButton

signal _character_class_changed(new_character_class: Class)

var character_class: Class = null:
	set(_character_class):
		character_class = _character_class
		_character_class_changed.emit(character_class)

func _init():
	list = Database.classes.get_all()

func _on_index_changed(_index: int):
	character_class = list[index]


func init(default_class: Class = null):
	if len(list) < 0:
		return

	if default_class == null:
		character_class = list[0]
	else:
		index = list.find(default_class, 0)
