extends SequenceMenu

@export var play: PackedScene
@export var options: PackedScene
@export var credits: PackedScene


func skip_condition() -> bool:
	return Launch.connection_strategy != null

func logical_next_step() -> PackedScene:
  return play

func _on_play_pressed():
	next_step(play)

func _on_options_pressed():
	next_step(options)

func _on_credits_pressed():
	next_step(credits)