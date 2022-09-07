extends DebugProperty

var label: Label3D = $"."

func update_value(value):
    label.text = str(value)