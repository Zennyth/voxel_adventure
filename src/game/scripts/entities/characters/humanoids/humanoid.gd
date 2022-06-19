extends Character
class_name Humanoid

enum Inventories {
    COSMETIC,
    EQUIPMENT,
    ITEM
}

var inventories: Dictionary = {
    COSMETIC = Inventory.new(DictionaryInventoryStore.new())
    EQUIPMENT = Inventory.new(DictionaryInventoryStore.new()),
    ITEM = = Inventory.new()
}

