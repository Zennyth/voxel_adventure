class_name NodeUtils

static func findNodeDescendantsInGroup(node: Node, groupName: String) -> Array:
	var descendantsInGroup := []
	for child in node.get_children():
		if child.is_in_group(groupName):
			descendantsInGroup.append(child)
		descendantsInGroup += findNodeDescendantsInGroup(child, groupName)
	return descendantsInGroup

static func recursive_get(object, path: String):
	if object == null:
		return null
	
	var properties = path.split(".")
	for property in properties:
		if not property in object:
			return null

		object = object.get(property)
	
	return object

static func recursive_has(object, path: String) -> bool:
	if object == null:
		return false
	
	var properties = path.split(".")
	for property in properties:
		if not property in object:
			return false

		object = object.get(property)
	
	return true

static func recursive_set(object, path: String, value):
	if object == null:
		return
	
	var properties = path.split(".")
	var last_index = len(properties) - 1
	var last_property = properties[last_index]
	properties.remove(last_index)


	for property in properties:
		if not property in object:
			return
		
		object = object.get(property)
	
	object.set(last_property, value)