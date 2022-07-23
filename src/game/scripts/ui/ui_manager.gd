extends RefCounted
class_name UIManager

# Is a menu open
signal _is_lock_changed(_is_lock: bool)
var is_lock: bool = false:
	set(_is_lock):
		is_lock = _is_lock
		_is_lock_changed.emit(is_lock)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if is_lock else Input.MOUSE_MODE_CAPTURED)
