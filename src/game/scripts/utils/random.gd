class_name RandomUtils

static func get_random_from_array(array: Array):
    randomize()
    return array[randi() % array.size()]