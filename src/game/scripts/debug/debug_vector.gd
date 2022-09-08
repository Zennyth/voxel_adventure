extends Control

class Vector:
	var object: Node
	var property: String  # The property to draw
	var scale: float  # Scale factor
	var width: float  # Line width
	var color: Color  # Draw color

	func _init(_object, _property, _scale, _width, _color):
		object = _object
		property = _property
		scale = _scale
		width = _width
		color = _color

	func draw(node, camera):
		var start = camera.unproject_position(object.global_transform.origin)
		var end = camera.unproject_position(object.global_transform.origin + object.get(property) * scale)
		node.draw_line(start, end, color, width)
		node.draw_triangle(end, start.direction_to(end), width*2, color)

var vectors := []

func _draw():
	for vector in vectors:
		vector.draw(self, get_viewport().get_camera())

func add_vector(object, property, _scale, width, color):
	vectors.append(Vector.new(object, property, _scale, width, color))
