extends Node3D

@onready var RaceCarousel: RaceCarouselButton = $SubViewport/VBoxContainer/Customization/Race/Race
@onready var ClassCarousel: ClassCarouselButton = $SubViewport/VBoxContainer/Customization/Class/Class
@onready var CosmeticCarousels = $SubViewport/VBoxContainer/Customization/Cosmetics
@onready var preview = $Preview

@export var character_scene: PackedScene

var character
var inventory: Inventory
var save_identifier: int

func _ready():
	save_identifier = CharacterSaveManager.generate_identifier()

	character = character_scene.instantiate()
	character.init({})
	add_child(character)
	character.Body.init_cosmetic_inventory()

	inventory = character.inventories[Inventory.InventoryCategory.CHARACTER_COSMETIC]
	
	var db := Database.items
	print(Database.items.get_by_name("Human Face 1"))
	inventory.get_slot(Cosmetic.CosmeticCategory.FACE).set_stack(Stack.new(db.get_by_name("Human Face 1"), 1))
	inventory.get_slot(Cosmetic.CosmeticCategory.CHEST).set_stack(Stack.new(db.get_by_name("Basic Warrior Chest Plate"), 1))
	inventory.get_slot(Cosmetic.CosmeticCategory.HANDS).set_stack(Stack.new(db.get_by_name("Basic Warrior Glove"), 1))
	inventory.get_slot(Cosmetic.CosmeticCategory.FEET).set_stack(Stack.new(db.get_by_name("Basic Warrior Shoe"), 1))

	for carousel in CosmeticCarousels.get_children():
		RaceCarousel._race_changed.connect(carousel._on_race_changed)
		carousel.init(inventory.get_slot(carousel.cosmetic_category))
    
    ClassCarousel._character_class_changed.connect(_on_class_changed)

#func save():
#	var save_manager := CharacterSaveManager.new() 
#	save_manager.set_save_path(save_identifier)
#	save_manager.save_inventory(Inventory.InventoryCategory.CHARACTER_COSMETIC, inventory)

func _on_class_changed(character_class: Class):
    character.character_class = character_class

