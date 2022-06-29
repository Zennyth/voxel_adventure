extends CarouselButton

@export var cosmetic_category: Cosmetic.CosmeticCategory

var slot: Slot
func init(_slot: Slot):
	slot = _slot

func _on_race_changed(race: Race):
	list = race.dictionary_cosmetics[cosmetic_category]
	index = 0

func _on_index_changed(_index: int):
	slot.set_stack(Stack.new(list[index], 1))
