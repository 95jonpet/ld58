class_name PlayerEngineParticles
extends GPUParticles2D

@onready var point_light_2d: PointLight2D = $PointLight2D


func _process(_delta: float) -> void:
	point_light_2d.enabled = emitting
