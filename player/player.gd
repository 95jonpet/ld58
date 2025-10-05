class_name Player
extends CharacterBody2D

const ROTATION_SPEED: float = 5.0
const MAX_SPEED: float = 192.0
const ACCELERATION: float = 48.0
const PLAYER_LASER_SPEED: float = 256.0
const PLAYER_LASER_SCENE: PackedScene = preload("res://player/player_laser.tscn")
const PLAYER_LASER_SHOOT: AudioStream = preload("res://player/player_laser_shoot.wav")
const PLAYER_HURT: AudioStream = preload("res://player/player_hurt.wav")

var _laser_ready: bool = true
@onready var _laser_timer: Timer = $LaserTimer
@onready var _laser_emitters: Node = $LaserEmitters
@onready var _engine_sound: AudioStreamPlayer = $EngineSound
@onready var _engine_particles: Array[GPUParticles2D] = [
	$EngineParticles1,
	$EngineParticles2,
]

func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		_shoot_lasers()

func _physics_process(delta: float) -> void:
	# Update the player's movement.
	rotation += Input.get_axis("rotate_counter_clockwise", "rotate_clockwise") * delta * ROTATION_SPEED
	_set_engine_particle_state(false)
	if Input.is_action_pressed("accelerate"):
		velocity += Vector2.from_angle(rotation) * ACCELERATION * delta
		velocity = velocity.normalized() * min(velocity.length(), MAX_SPEED)
		_set_engine_particle_state(true)
		_engine_sound.pitch_scale = 0.85 + (velocity.length() / MAX_SPEED) * 2
		if not _engine_sound.playing:
			_engine_sound.play()
	else:
		_engine_sound.stop()

	if move_and_collide(velocity * delta):
		print_debug("TODO: Handle collisions")
		get_tree().reload_current_scene()
	Globals.player_position = global_position

func _on_laser_timer_timeout() -> void:
	_laser_ready = true

func _set_engine_particle_state(emitting: bool) -> void:
	for emitter in _engine_particles:
		emitter.emitting = emitting

func _shoot_lasers() -> void:
	if not _laser_ready:
		return

	AudioPlayer.play(PLAYER_LASER_SHOOT)
	for emitter in _laser_emitters.get_children():
		_shoot_laser(emitter as Marker2D)

	_laser_ready = false
	_laser_timer.start()

func _shoot_laser(emitter: Marker2D) -> void:
	var laser: PlayerLaser = PLAYER_LASER_SCENE.instantiate() as PlayerLaser
	add_sibling(laser)
	laser.global_position = emitter.global_position
	laser.rotation = rotation
	laser.velocity = velocity + Vector2.from_angle(laser.rotation) * PLAYER_LASER_SPEED

func _on_hitbox_body_entered(body: Node2D) -> void:
	body.queue_free()
	AudioPlayer.play(PLAYER_HURT)
	ScreenShake.apply_shake(8)
	Globals.player_health -= 1
