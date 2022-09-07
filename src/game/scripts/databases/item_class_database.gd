extends ResourceDatabase

var _item_classes: Dictionary = {}

func init():
	for file in FilesUtils.get_files_from_folder("res://scripts/items/items/"):
		var item_class = load(file)
		_item_classes[item_class.get_item_class()] = file


func get_by_name(name_item_class: String):
	if not name_item_class in _item_classes:
		return null
	
	return load(_item_classes[name_item_class]).new()


func get_all() -> Array:
	return _item_classes.values()


###
# BUILT-IN
# Networking
###
func parse_item(data) -> Item:
	if data == null:
		return null

	var item = get_by_name(data["i"])

	for property in data["p"]:
		var vt = data["p"][property]
		
		if "t" in vt and vt["t"].contains("Mesh"):
			item[property] = bytes2var_with_objects(data["p"][property]["v"])
		else:
			item[property] = vt["v"]

	return item

func dump_item(new_item):
	if new_item == null:
		return null

	var data = {
		"i": new_item.get_item_class(),
		"p": {}
	}

	for property in new_item.get_property_list():
		var value = new_item.get(property["name"])

		if value == null or property["usage"] != 4102:
			continue

		data["p"][property["name"]] = {
			"v": value
		}
		
		if value is Object:
			data["p"][property["name"]]["t"] = value.get_class()
			
			if value.get_class().contains("Mesh"):
				data["p"][property["name"]]["v"] = var2bytes_with_objects(value)
	return data


func parse_stack(data) -> Stack:
	if data == null:
		return null
	
	return Stack.new(parse_item(data["i"]), data["q"])

func dump_stack(stack):
	if stack == null:
		return null
	
	return {
		"q": stack.quantity,
		"i": dump_item(stack.get_item())
	}
