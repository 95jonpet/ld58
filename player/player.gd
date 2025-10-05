class_name Player
extends CharacterBody2D

const ROTATION_SPEED: float = 5.0
const MAX_SPEED: float = 32.0
const ACCELERATION: float = 1.0
const PLAYER_LASER_SPEED: float = 256.0
const PLAYER_LASER_SCENE: PackedScene = preload("res://player/player_laser.tscn")

@onready var _laser_emitters: Node = $LaserEmitters
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

func _on_timer_timeout() -> void:
	_shoot_lasers()

func _set_engine_particle_state(emitting: bool) -> void:
	for emitter in _engine_particles:
		emitter.emitting = emitting

func _shoot_lasers() -> void:
	for emitter in _laser_emitters.get_children():
		_shoot_laser(emitter as Marker2D)

func _shoot_laser(emitter: Marker2D) -> void:
	var laser: PlayerLaser = PLAYER_LASER_SCENE.instantiate() as PlayerLaser
	add_sibling(laser)
	laser.global_position = emitter.global_position
	laser.rotation = rotation
	laser.velocity = velocity + Vector2.from_angle(laser.rotation) * PLAYER_LASER_SPEED
