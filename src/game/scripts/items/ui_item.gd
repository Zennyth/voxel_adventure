extends SubViewportContainer
class_name ItemContainer


# @onready var texture_rect: TextureRect = $TextureRect
@onready var mesh_instance: MeshInstance3D = $SubViewport/MeshInstance3D

func _ready():
	# texture_rect.texture = null
	mesh_instance.mesh = null
	pass

var item: Item = null:
	set(_item):
		item = _item
		mesh_instance.mesh = item.get_mesh() if item and item.get_mesh() else null

func set_item(_item: Item):
	item = _item

func get_item_name() -> String:
	return item.get_name()
