extends Node3D

@onready var RaceCarousel: RaceCarouselButton = $SubViewport/VBoxContainer/Customization/Race/Race
@onready var ClassCarousel: ClassCarouselButton = $SubViewport/VBoxContainer/Customization/Class/Class
@onready var CosmeticCarousels = $SubViewport/VBoxContainer/Customization/Cosmetics
@onready var preview = $Preview
@onready var NameInput := $SubViewport/Actions/LineEdit
@onready var CreateButton := $SubViewport/Actions/Button

@export var character_scene: PackedScene


var character
var inventory: Inventory
var save_manager: CharacterSaveManager = Game.character_save_manager

func _ready():
	save_manager.set_save_path(CharacterSaveManager.generate_identifier())
	
	# init character
	character = character_scene.instantiate()
	character.data = DataManager.new()
	character.init({})
	preview.add_child(character)
	character.Body.bind_cosmetic_inventory()
	inventory = character.data.get_inventory(Inventory.InventoryCategory.CHARACTER_COSMETIC)
	
	for carousel in CosmeticCarousels.get_children():
		RaceCarousel._race_changed.connect(carousel._on_race_changed)
		carousel.init(inventory.get_slot(carousel.cosmetic_category))
	RaceCarousel._race_changed.connect(_on_race_changed)
	
	ClassCarousel._character_class_changed.connect(_on_class_changed)
	
	RaceCarousel.init() 
	ClassCarousel.init()
	
	CreateButton.pressed.connect(create_character)
	
	NameInput.text = character.data.character_name 

func create_character():
	character.data.character_name = NameInput.text 
	save_manager.save_character(character.data)

func _on_class_changed(character_class: Class):
	character.data.character_class = character_class

func _on_race_changed(character_race: Race):
	character.data.character_race = character_race
	inventory.get_slot(Cosmetic.CosmeticCategory.HANDS).set_stack(Stack.new(character_race.dictionary_cosmetics[Cosmetic.CosmeticCategory.HANDS][0], 1))

