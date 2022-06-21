extends Character
class_name Humanoid

var inventories: Dictionary = {
	COSMETIC = InventoryResource.new(DictionaryInventoryStore.new()),
	EQUIPMENT = InventoryResource.new(DictionaryInventoryStore.new()),
	ITEM = InventoryResource.new()
}

