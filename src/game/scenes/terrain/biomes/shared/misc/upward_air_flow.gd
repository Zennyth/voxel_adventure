extends Node

@onready var air_flux: Area3D = $AirFlux

func _physics_process(_delta):
	for entity in air_flux.get_overlapping_bodies():
		if not entity is CharacterBody3D:
			continue
		
		entity.velocity += Vector3.UP * 2
