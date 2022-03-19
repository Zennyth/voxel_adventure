extends RigidDynamicBody3D

signal exploded

@export
var init_velocity: float = 25

var direction: Vector3 = Vector3.UP * 20
var velocity = Vector3.ZERO

func _ready():
	set_physics_process(false)

func launch(start_position: Vector3, start_direction: Vector3):
	transform.origin = start_position
	direction = start_direction
	velocity = direction * init_velocity
	set_physics_process(true)
	
	var timer = get_node("Timer")
	timer.set_wait_time( 5 )
	timer.connect("timeout", destroy)
	timer.start()

func destroy():
	queue_free()

func _physics_process(delta):
	velocity += direction * delta
	global_translate(velocity * delta)

func _on_Shell_body_entered(body):
	emit_signal("exploded", transform.origin)
	queue_free()
