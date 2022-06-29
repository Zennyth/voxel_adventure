extends Node3D

@onready var RaceCarousel: RaceCarouselButton = $RaceCarousel
@onready var CosmeticCarousels = $CosmeticCarousels

var character: Humanoid
var inventory: Inventory

func _ready():
    var save_identifier: int = CharacterSaveManager.generate_identifier()

    character = Humanoid.instantiate()
    character.init({})
    add_child(character)
    character.HumanoidBody.init_cosmetic_inventory()

    inventory = character.inventories[Inventory.InventoryCategory.CHARACTER_COSMETIC]

    for carousel in CosmeticCarousels.get_children():
        carousel.connect("_on_race_changed", RaceCarousel._race_changed)
        carousel.init(inventory.get_slot(carousel.cosmetic_category))


func save():
    CharacterSaveManager.set_save_path(save_identifier)
    CharacterSaveManager.save_inventory(Inventory.InventoryCategory.CHARACTER_COSMETIC, inventory)