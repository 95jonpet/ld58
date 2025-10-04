class_name Salvage
extends CharacterBody2D

signal salvage_collected()

const GRAPPLE_ACCELERATION: float = 6.0

var health: float = 3.0
@onready var grapple_particles: GPUParticles2D = $GrappleParticles


func _process(_delta: float) -> void:
	grapple_particles.emitting = false
	if move_and_slide():
		velocity = Vector2.ZERO
	if health <= 0:
		salvage_collected.emit()

func _on_grapple_area_apply_grapple(grappler: Area2D, delta: float) -> void:
	var grapple_angle := global_position.angle_to_point(grappler.global_position)
	var grapple_direction := Vector2.from_angle(grapple_angle)
	velocity += grapple_direction * GRAPPLE_ACCELERATION * delta
	grapple_particles.emitting = true

	var grapple_particles_material: ParticleProcessMaterial = grapple_particles.process_material
	grapple_particles_material.direction = Vector3(grapple_direction.x, grapple_direction.y, 0)

	health -= delta
