extends SequenceMenu

@export var connection_strategy_picker: PackedScene

func skip_condition() -> bool:
	return Launch.connection_strategy != null

func logical_next_step() -> PackedScene:
  return connection_strategy_picker