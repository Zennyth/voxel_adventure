extends SequenceMenu

@export var steam: PackedScene
@export var enet: PackedScene
@export var solo: PackedScene


func skip_condition() -> bool:
	return Launch.network != null

func logical_next_screen() -> PackedScene:
	return solo

func _on_steam_pressed():
	next_screen(steam)

func _on_enet_pressed():
	next_screen(enet)

func _on_solo_pressed():
	next_screen(solo)
