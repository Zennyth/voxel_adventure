extends Resource
class_name Race

@export var name := ""
@export var cosmetics: Array = []

var dictionary_cosmetics := {}

func init():
	dictionary_cosmetics = {}
	for cosmetic in cosmetics:
		if not cosmetic:
			continue
		
		if not cosmetic.cosmetic_category in dictionary_cosmetics:
			dictionary_cosmetics[cosmetic.cosmetic_category] = []

		dictionary_cosmetics[cosmetic.cosmetic_category].append(cosmetic)
