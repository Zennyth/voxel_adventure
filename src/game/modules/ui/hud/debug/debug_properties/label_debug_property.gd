@tool
extends DebugProperty

@export var prefix: String = "":
	set(value):
		prefix = value
		update_value("")

var label: Label = $"."

func update_value(value):
	label.text = prefix + ": " + str(value)
