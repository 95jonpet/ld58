class_name Game
extends Node

const GAME_SIZE: int = 2048
const NEBULA_COUNT: int = 64
const STAR_COUNT: int = 512
const INDICATOR_DISTANCE: int = 128
const BORDER_SIZE: int = 1024
const NEBULA: PackedScene = preload("res://environment/nebula.tscn")
const STAR: PackedScene = preload("res://environment/star.tscn")
const SALVAGE_SCENE: PackedScene = preload("res://salvage/salvage.tscn")
const PLAYER_HURT: AudioStream = preload("res://player/player_hurt.wav")

@onready var background: ColorRect = $Background
@onready var north_border: ColorRect = $Borders/NorthBorder
@onready var south_border: ColorRect = $Borders/SouthBorder
@onready var east_border: ColorRect = $Borders/EastBorder
@onready var west_border: ColorRect = $Borders/WestBorder

@onready var camera: Camera = $Camera
@onready var player: Player = $Player
@onready var nebulae: Node = $Nebulae
@onready var stars: Node = $Stars
@onready var salvage: Salvage = $Salvage
@onready var salvage_indicator: Sprite2D = $Camera/SalvageIndicator
@onready var danger_indicator: Sprite2D = $Camera/DangerIndicator
@onready var missile_platform: MissilePlatform = $MissilePlatform
@onready var out_of_area_timer: Timer = $OutOfAreaTimer


func _ready() -> void:
	_generate_nebulae()
	_generate_stars()
	_generate_salvage()
	_generate_missile_plattform()

	background.position = Vector2(-BORDER_SIZE, -BORDER_SIZE)
	background.size = Vector2(GAME_SIZE + BORDER_SIZE * 2, GAME_SIZE + BORDER_SIZE * 2)

	north_border.position = Vector2(0, -BORDER_SIZE)
	north_border.size = Vector2(GAME_SIZE, BORDER_SIZE)
	south_border.position = Vector2(0, GAME_SIZE)
	south_border.size = Vector2(GAME_SIZE, BORDER_SIZE)
	east_border.position = Vector2(GAME_SIZE, -BORDER_SIZE)
	east_border.size = Vector2(BORDER_SIZE, GAME_SIZE + BORDER_SIZE * 2)
	west_border.position = Vector2(-BORDER_SIZE, -BORDER_SIZE)
	west_border.size = Vector2(BORDER_SIZE, GAME_SIZE + BORDER_SIZE * 2)

	player.position = Vector2(GAME_SIZE / 2.0, GAME_SIZE / 2.0)
	camera.snap_to_position(player.position)

func _process(delta: float) -> void:
	camera.target_position = player.global_position
	camera.offset = ScreenShake.get_noise_offset(delta)

	_update_indicator(salvage_indicator, salvage.global_position)
	_update_indicator(danger_indicator, missile_platform.global_position)

	var game_area := Rect2(0, 0, GAME_SIZE, GAME_SIZE)
	var player_in_game_area := game_area.has_point(player.position)
	north_border.color.a = 0.25 if player_in_game_area else 0.5
	south_border.color.a = 0.25 if player_in_game_area else 0.5
	east_border.color.a = 0.25 if player_in_game_area else 0.5
	west_border.color.a = 0.25 if player_in_game_area else 0.5

	if player_in_game_area:
		out_of_area_timer.stop()
	elif out_of_area_timer.is_stopped():
		out_of_area_timer.start()

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
			missile_platform.position = Vector2(randi_range(0, GAME_SIZE), 0)
		"south":
			missile_platform.position = Vector2(randi_range(0, GAME_SIZE), GAME_SIZE)
		"east":
			missile_platform.position = Vector2(GAME_SIZE, randi_range(0, GAME_SIZE))
		"west":
			missile_platform.position = Vector2(0, randi_range(0, GAME_SIZE))

func _generate_salvage() -> void:
	salvage.queue_free()

	salvage = SALVAGE_SCENE.instantiate() as Salvage
	salvage.salvage_collected.connect(_on_salvage_collected)
	add_child(salvage)
	salvage.position = Vector2i(randi_range(0, GAME_SIZE), randi_range(0, GAME_SIZE))

func _generate_nebulae() -> void:
	for _i in range(0, NEBULA_COUNT):
		var nebula := NEBULA.instantiate() as Node2D
		nebula.position = Vector2i(
			randi_range(-BORDER_SIZE, GAME_SIZE + BORDER_SIZE),
			randi_range(-BORDER_SIZE, GAME_SIZE + BORDER_SIZE)
		)
		nebulae.add_child(nebula)

func _generate_stars() -> void:
	for _i in range(0, STAR_COUNT):
		var star := STAR.instantiate() as Node2D
		star.position = Vector2i(
			randi_range(-BORDER_SIZE, GAME_SIZE + BORDER_SIZE),
			randi_range(-BORDER_SIZE, GAME_SIZE + BORDER_SIZE)
		)
		stars.add_child(star)

func _on_timer_timeout() -> void:
	_generate_missile_plattform()

func _on_out_of_area_timer_timeout() -> void:
	Globals.player_health -= 1
	AudioPlayer.play(PLAYER_HURT)
	ScreenShake.apply_shake(25)
