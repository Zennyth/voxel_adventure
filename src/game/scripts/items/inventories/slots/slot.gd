extends Panel
class_name Slot

var default_texture = preload("res://assets/items/inventories/item_slot_default_background.png")
var empty_texture = preload("res://assets/items/inventories/item_slot_empty_background.png")

var default_style := StyleBoxTexture.new()
var empty_style := StyleBoxTexture.new()

@onready var item_texture: TextureRect = $ItemTexture

var stack: StackResource = null:
	set(_stack):
		stack = _stack
		
		if stack != null:
			var _item: ItemResource = stack.item
			item_texture.texture = _item.icon if _item and _item.icon else null
		
		refresh_style()

func refresh_style():
	set('theme_override_styles/panel', empty_style if stack == null else default_style)

func _ready():
	add_to_group("slots")
	default_style.texture = default_texture
	empty_style.texture = empty_texture
	
	if randi() % 2 == 0:
		stack = StackResource.new(ItemDatabase.get_item("Basic Warrior Chest Plate"), 1)
	else:
		stack = null
