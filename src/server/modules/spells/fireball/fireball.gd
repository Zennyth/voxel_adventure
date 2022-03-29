extends Area3D

signal exploded

@export
var init_velocity: float = 35

var direction: Vector3 = Vector3.UP * 20
var velocity = Vector3.ZERO

func _ready() -> void:
	hide()
	set_physics_process(false)

func launch(start_position: Vector3, start_direction: Vector3) -> void:
	transform.origin = start_position
	direction = start_direction
	velocity = direction * init_velocity
	
	show()
	set_physics_process(true)
	
	var timer = get_node("Timer")
	timer.set_wait_time( 5 )
	timer.connect("timeout", destroy)
	timer.start()

func destroy() -> void:
	queue_free()

func _physics_process(delta: float) -> void:
	velocity += direction * delta
	global_translate(velocity * delta)

func _on_fireball_body_entered(node):
	if node is Character:
		node.on_hit(5)
		destroy()
