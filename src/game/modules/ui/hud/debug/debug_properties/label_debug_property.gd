@tool
extends DebugProperty

@export var prefix: String = "":
	set(value):
		prefix = value
		update_value()

@export var suffix: String = "":
	set(value):
		suffix = value
		update_value()

@export var default: String = "":
	set(value):
		default = value
		update_value()

var label: Label = $"."

func update_value(value = null):
	label.text = prefix + ": " + (str(value) if value != null else default) + " " + suffix
