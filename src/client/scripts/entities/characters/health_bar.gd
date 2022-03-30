extends Node3D

var bar_red = preload("res://assets/entities/characters/health_bar/barHorizontal_red.png")
var bar_green = preload("res://assets/entities/characters/health_bar/barHorizontal_green.png")
var bar_yellow = preload("res://assets/entities/characters/health_bar/barHorizontal_yellow.png")

@onready var healthbar = $SubViewportContainer/HealthBar

func update_healthbar(value, max_value):
	healthbar.texture_progress = bar_green
	healthbar.max_value = max_value
	if value < healthbar.max_value * 0.7:
		healthbar.texture_progress = bar_yellow
	if value < healthbar.max_value * 0.35:
		healthbar.texture_progress = bar_red
	if value < healthbar.max_value:
		show()
	healthbar.value = value
