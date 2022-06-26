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
	
	init_item_inventory()
	EventBus.player_initialized.emit(self)

func init_item_inventory():
	var inventory: ArrayInventory = load_inventory()
	
	if not inventory:
		inventory = ArrayInventory.new(20)
		for slot in inventory.get_slots():
			if randf() > .5:
				slot.set_stack(Stack.new(ItemDatabase.get_item("Human Face 1"), 1))
		save()
	
	inventories[Inventory.InventoryKey.ITEM_INVENTORY] = inventory


####
## SAVE/LOAD
####

var item_inventory_file_path := "res://save/player/test.tres"

func save():
	var result = ResourceSaver.save(item_inventory_file_path, inventories[Inventory.InventoryKey.ITEM_INVENTORY])
	return result

func load_inventory() -> ArrayInventory:
	if ResourceLoader.exists(item_inventory_file_path):
		var inventory = ResourceLoader.load(item_inventory_file_path)
		return inventory as ArrayInventory
	
	return null
