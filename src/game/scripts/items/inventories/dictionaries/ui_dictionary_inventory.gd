extends InventoryContainer
class_name DictionaryInventoryContainer

func random_populate():
	inventory = DictionaryInventory.new(range(20))

	for slot in inventory.slots:
		if randf() > 0.5:
			slot.set_stack(Stack.new(ItemDatabase.get_item("Basic Warrior Chest Plate"), 1))
