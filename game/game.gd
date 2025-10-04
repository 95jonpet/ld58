class_name Game
extends Node

const GAME_SIZE: int = 1024
const STAR_COUNT: int = 256
const SALVAGE_INDICATOR_DISTANCE: int = 128
const STAR: PackedScene = preload("res://environment/star.tscn")

@onready var camera: Camera = $Camera
@onready var player: Player = $Player
@onready var stars: Node = $Stars
@onready var salvage: Salvage = $Salvage
@onready var salvage_indicator: Sprite2D = $Camera/SalvageIndicator


func _ready() -> void:
	_generate_stars()

func _process(delta: float) -> void:
	camera.target_position = player.global_position
	camera.offset = ScreenShake.get_noise_offset(delta)

	var viewport_size := camera.get_viewport_rect().size
	var indicator_size := salvage_indicator.texture.get_size()
	var salvage_angle := camera.global_position.angle_to_point(salvage.global_position)
	salvage_indicator.position = (camera.global_position - player.global_position) + Vector2.from_angle(salvage_angle) * SALVAGE_INDICATOR_DISTANCE
	salvage_indicator.position = salvage_indicator.position.clamp(
		-(viewport_size / 2) + indicator_size,
		viewport_size / 2 - indicator_size,
	)

	var bounds := Rect2i(camera.global_position - viewport_size / 2, viewport_size)
	if bounds.has_point(salvage.global_position):
		salvage_indicator.hide()
	else:
		salvage_indicator.show()

func _generate_stars() -> void:
	for _i in range(0, STAR_COUNT):
		var star: Node2D = STAR.instantiate()
		star.position = Vector2i(
			randi_range(-GAME_SIZE, GAME_SIZE),
			randi_range(-GAME_SIZE, GAME_SIZE)
		)
		stars.add_child(star)
