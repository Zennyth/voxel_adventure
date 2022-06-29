extends InventoryContainer
class_name ArrayInventoryContainer

func random_populate():
	inventory = ArrayInventory.new(20)

	for slot in inventory.slots:
		if randf() > 0.5:
			slot.set_stack(Stack.new(Database.item.get("Basic Warrior Chest Plate"), 1))
