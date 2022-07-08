extends CarouselButton

@export var cosmetic_category: Cosmetic.CosmeticCategory

var key

var slot: Slot
func init(_slot: Slot):
	slot = _slot
	slot._stack_changed.connect(_on_stack_changed)

func _ready():
	key = Cosmetic.get_key(cosmetic_category)
	super._ready()

func _init():
	_index_changed.connect(_on_index_changed)


func _on_race_changed(race: Race):
	list = race.dictionary_cosmetics[cosmetic_category]
	index = 0

func _on_index_changed(_index: int):
	print(index)
	slot.set_stack(Stack.new(list[index], 1))

func _on_stack_changed(stack: Stack):
	if not stack or stack.is_empty():
		return

	var next_index: int = list.find(stack.item, 0)
	if index == -1:
		return

	index = next_index

