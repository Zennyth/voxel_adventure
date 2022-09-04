extends Entity
class_name PickupItem

@onready var mesh_instance: MeshInstance3D = $"MeshInstance3D"
@onready var label: Label3D = $"Label3D"

var pickup_item: Node3D
func _init():
	pickup_item = $"." as Node3D


var stack := Stack.new()

var quantity := bind_property("stack.quantity", "q", true, {
	"on_changed": func(new_quantity: int): label.text = str(new_quantity)
})

var item := bind_property("stack.item", "i", true, {
	"on_changed": func(new_item: Item): mesh_instance.mesh = new_item.get_mesh() if new_item else null,
	"parse": Database.item_classes.parse_item,
	"dump": Database.item_classes.dump_item
})

func pickup(desired_quantity: int = 1):
	var remaining_quantity = quantity.get_value() - desired_quantity
	if remaining_quantity < 0:
		return
	
	quantity.set_value(remaining_quantity)
#	if remaining_quantity == 0:
#		destroy()



var sync_position := bind_property("position", WorldState.STATE_KEYS.POSITION, false)
var sync_rotation := bind_property("rotation", WorldState.STATE_KEYS.ROTATION, false)

func _ready():
	set_physics_process(is_authoritative())

func _process(_delta: float):
	update_unstable_state()
