extends Humanoid
class_name Player

@onready var springArmPlayer: SpringArmPlayer = $SpringArmPlayer
@onready var voxelViewer: VoxelViewer = $VoxelViewer
# @onready var label: LabelComponent = $Label3D

func _ready():
	super._ready()
	
	if not is_authoritative():
		voxelViewer.process_mode = Node.PROCESS_MODE_DISABLED
		return
	
	EventBus.player_initialized.emit(self)

# func init_item_inventory():
# 	var inventory: ArrayInventory = load_inventory()
	
# 	if not inventory:
# 		inventory = ArrayInventory.new(20)
# 		for slot in inventory.get_slots():
# 			if randf() > .5:
# 				slot.set_stack(Stack.new(ItemDatabase.get_item("Human Face 1"), 1))
# 		save()
	
# 	inventories[Inventory.InventoryKey.ITEM_INVENTORY] = inventory
