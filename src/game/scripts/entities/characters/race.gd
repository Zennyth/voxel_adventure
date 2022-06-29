extends Resource
class_name Race

@export var name := ""
@export var cosmetics := []

var dictionary_cosmetics := {}


func _init():
    for cosmetic in cosmetics:
        if not cosmetic.cosmetic_category in dictionary_cosmetics:
            dictionary_cosmetics[cosmetic.cosmetic_category] = []
        
        dictionary_cosmetics[cosmetic.cosmetic_category].append(cosmetic)