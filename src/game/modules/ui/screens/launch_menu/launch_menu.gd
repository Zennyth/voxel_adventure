extends SequenceMenu

@export var play: PackedScene
@export var options: PackedScene
@export var credits: PackedScene


var skip: bool:
	get():
		return Launch.connection_strategy != null

func _init():
	if !is_previous and skip:
		next_step(play)


func _on_play_pressed():
	next_step(play)

func _on_options_pressed():
	next_step(options)

func _on_credits_pressed():
	next_step(credits)