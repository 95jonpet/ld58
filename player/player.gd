class_name Player
extends CharacterBody2D

const ROTATION_SPEED: float = 5.0
const MAX_SPEED: float = 32.0
const ACCELERATION: float = 1.0

@onready var _engine_particles: Array[GPUParticles2D] = [
	$EngineParticles1,
	$EngineParticles2,
]


func _physics_process(delta: float) -> void:
	# Update the player's movement.
	rotation += Input.get_axis("ui_left", "ui_right") * delta * ROTATION_SPEED
	_set_engine_particle_state(false)
	if Input.is_action_pressed("ui_up"):
		velocity += Vector2.from_angle(rotation) * ACCELERATION * delta
		velocity = velocity.normalized() * min(velocity.length(), MAX_SPEED)
		_set_engine_particle_state(true)
	move_and_collide(velocity)

func _set_engine_particle_state(emitting: bool) -> void:
	for emitter in _engine_particles:
		emitter.emitting = emitting
