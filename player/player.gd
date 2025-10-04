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
	rotation += Input.get_axis("rotate_counter_clockwise", "rotate_clockwise") * delta * ROTATION_SPEED
	_set_engine_particle_state(false)
	if Input.is_action_pressed("accelerate"):
		velocity += Vector2.from_angle(rotation) * ACCELERATION * delta
		velocity = velocity.normalized() * min(velocity.length(), MAX_SPEED)
		_set_engine_particle_state(true)

	if move_and_collide(velocity):
		print_debug("TODO: Handle collisions")
		get_tree().reload_current_scene()
	Globals.player_position = global_position

func _set_engine_particle_state(emitting: bool) -> void:
	for emitter in _engine_particles:
		emitter.emitting = emitting
