extends Node2D
class_name ItemContainer


@onready var texture_rect: TextureRect = $TextureRect


var item: Item = null:
	set(_item):
		item = _item
		texture_rect.texture = item.icon if item and item.icon else null

func set_item(_item: Item):
	item = _item

func get_item_name() -> String:
	return item.name
