class_name Star
extends Node2D

const TIMER_MIN_WAIT_TIME: float = 0.5
const TIMER_MAX_WAIT_TIME: float = 3.0

const TEXTURES: Array[Texture2D] = [
	preload("res://environment/star.png"),
	preload("res://environment/star2.png"),
	preload("res://environment/star3.png"),
]

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer


func _ready() -> void:
	_randomize_texture()
	_randomize_wait_time()

func _on_timer_timeout() -> void:
	_randomize_texture()
	_randomize_wait_time()

func _randomize_texture() -> void:
	sprite.texture = TEXTURES.pick_random()

func _randomize_wait_time() -> void:
	timer.wait_time = randf_range(TIMER_MIN_WAIT_TIME, TIMER_MAX_WAIT_TIME)
