class_name Game
extends Node

const GAME_SIZE: int = 1024
const NEBULA_COUNT: int = 16
const STAR_COUNT: int = 256
const INDICATOR_DISTANCE: int = 128
const NEBULA: PackedScene = preload("res://environment/nebula.tscn")
const STAR: PackedScene = preload("res://environment/star.tscn")
const SALVAGE_SCENE: PackedScene = preload("res://salvage/salvage.tscn")

@onready var camera: Camera = $Camera
@onready var player: Player = $Player
@onready var nebulae: Node = $Nebulae
@onready var stars: Node = $Stars
@onready var salvage: Salvage = $Salvage
@onready var salvage_indicator: Sprite2D = $Camera/SalvageIndicator
@onready var danger_indicator: Sprite2D = $Camera/DangerIndicator
@onready var missile_platform: MissilePlatform = $MissilePlatform


func _ready() -> void:
	_generate_nebulae()
	_generate_stars()
	_generate_salvage()
	_generate_missile_plattform()

func _process(delta: float) -> void:
	camera.target_position = player.global_position
	camera.offset = ScreenShake.get_noise_offset(delta)

	_update_indicator(salvage_indicator, salvage.global_position)
	_update_indicator(danger_indicator, missile_platform.global_position)

func _on_salvage_collected() -> void:
	_generate_salvage()

func _update_indicator(indicator: Sprite2D, target_position: Vector2) -> void:
	var viewport_size := camera.get_viewport_rect().size
	var indicator_size := indicator.texture.get_size()
	var angle_to_target := camera.global_position.angle_to_point(target_position)
	indicator.position = (camera.global_position - player.global_position) + Vector2.from_angle(angle_to_target) * INDICATOR_DISTANCE
	indicator.position = indicator.position.clamp(
		-(viewport_size / 2) + indicator_size,
		viewport_size / 2 - indicator_size,
	)

	var bounds := Rect2i(camera.global_position - viewport_size / 2, viewport_size)
	if bounds.has_point(target_position):
		indicator.hide()
	else:
		indicator.show()

func _generate_missile_plattform() -> void:
	var side: String = ["north", "south", "east", "west"].pick_random() as String
	match side:
		"north":
			missile_platform.position = Vector2(randi_range(-GAME_SIZE, GAME_SIZE), -GAME_SIZE)
		"south":
			missile_platform.position = Vector2(randi_range(-GAME_SIZE, GAME_SIZE), GAME_SIZE)
		"east":
			missile_platform.position = Vector2(GAME_SIZE, randi_range(-GAME_SIZE, GAME_SIZE))
		"west":
			missile_platform.position = Vector2(-GAME_SIZE, randi_range(-GAME_SIZE, GAME_SIZE))

func _generate_salvage() -> void:
	salvage.queue_free()

	salvage = SALVAGE_SCENE.instantiate() as Salvage
	salvage.salvage_collected.connect(_on_salvage_collected)
	add_child(salvage)
	salvage.position = Vector2i(
		randi_range(-GAME_SIZE, GAME_SIZE),
		randi_range(-GAME_SIZE, GAME_SIZE)
	)

func _generate_nebulae() -> void:
	for _i in range(0, NEBULA_COUNT):
		var nebula := NEBULA.instantiate() as Node2D
		nebula.position = Vector2i(
			randi_range(-GAME_SIZE, GAME_SIZE),
			randi_range(-GAME_SIZE, GAME_SIZE)
		)
		nebulae.add_child(nebula)

func _generate_stars() -> void:
	for _i in range(0, STAR_COUNT):
		var star := STAR.instantiate() as Node2D
		star.position = Vector2i(
			randi_range(-GAME_SIZE, GAME_SIZE),
			randi_range(-GAME_SIZE, GAME_SIZE)
		)
		stars.add_child(star)

func _on_timer_timeout() -> void:
	_generate_missile_plattform()
