extends SaveManager
class_name CharacterSaveManager

var folder_path := "characters/"

func get_inventory_path(category: Inventory.InventoryCategory) -> str:
    return full_path + "inventories/" + str(category)

func save_inventory(category: Inventory.InventoryCategory, inventory: Inventory):
    ResourceSaver.save(get_inventory_path(category), inventory)

func load_inventory(category: Inventory.InventoryCategory) -> Inventory:
    var path := get_inventory_path(category)

    if ResourceLoader.exists(path):
        var inventory = ResourceLoader.load(path)
        return inventory as Inventory
    
    return null