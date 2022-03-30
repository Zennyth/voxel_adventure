extends Area3D

signal exploded

@export var init_velocity: float = 35
@export var cooldown: float = .5 # sec
@export var ttl: float = 5 # sec

var direction: Vector3 = Vector3.UP * 20
var velocity = Vector3.ZERO

@onready var _explosion: GPUParticles3D = $Explosion

func _ready() -> void:
	hide()
	set_physics_process(false)

func launch(start_position: Vector3, start_direction: Vector3) -> void:
	transform.origin = start_position
	direction = start_direction
	velocity = direction * init_velocity
	
	show()
	set_physics_process(true)
	
	var timer = get_node("TTL")
	timer.set_wait_time( ttl )
	timer.connect("timeout", explode)
	timer.start()

func explode() -> void:
	var timer = get_node("ExplosionTimer")
	timer.set_wait_time( .5 )
	timer.connect("timeout", destroy)
	timer.start()
	
	var trail = get_node("Trail")
	trail.hide()
	
	set_physics_process(false)
	_explosion.emitting = true
	_explosion.restart()

func destroy() -> void:
	queue_free()
	

func _physics_process(delta: float) -> void:
	velocity += direction * delta
	global_translate(velocity * delta)

func _on_fireball_body_entered(node):
	if node.get_parent() is Character:
		explode()
		# node.get_parent().hit(5)	
