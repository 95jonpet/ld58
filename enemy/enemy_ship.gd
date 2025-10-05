extends CharacterBody2D

const SPEED: float = 64.0
const MAX_DISTANCE: float = 128
const MISSILE_SPEED: float = 256.0
const MISSILE_SCENE: PackedScene = preload("res://missile/missile.tscn")
const PLAYER_HURT: AudioStream = preload("res://player/player_hurt.wav")


func _ready() -> void:
	_set_navigation_target(Globals.player_position)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_missile_timer_timeout() -> void:
	_shoot_missile()

func _on_navigation_timer_timeout() -> void:
	_set_navigation_target(Globals.player_position)

func _set_navigation_target(target_position: Vector2) -> void:
	rotation = global_position.angle_to_point(target_position)
	velocity = Vector2.from_angle(rotation) * SPEED

	var max_distance_squared: float = MAX_DISTANCE * MAX_DISTANCE
	if global_position.distance_squared_to(target_position) < max_distance_squared:
		velocity = Vector2.ZERO

func _shoot_missile() -> void:
	var missile: Missile = MISSILE_SCENE.instantiate() as Missile
	add_sibling(missile)
	missile.position = position
	missile.rotation = global_position.direction_to(Globals.player_position).angle()
	missile.rotation += randf_range(-deg_to_rad(2), deg_to_rad(2))
	missile.velocity = Vector2.from_angle(missile.rotation) * MISSILE_SPEED


func _on_hitbox_body_entered(body: Node2D) -> void:
	AudioPlayer.play(PLAYER_HURT)
	body.queue_free()
	queue_free()
