class_name Main
extends Node

@onready var _viewport_container: SubViewportContainer = $SubViewportContainer
@onready var _health_indicator_template: TextureRect = $HealthIndicatorTemplate
@onready var _health_indicator_container: HBoxContainer = $HealthIndicatorContainer
@onready var _game_over: Control = $GameOver
@onready var _game: Game = $SubViewportContainer/SubViewport/Game
var _health_indicators: Array[TextureRect] = []
const MUSIC_1 = preload("res://game/music1.wav")


func _ready() -> void:
	MusicPlayer.play([MUSIC_1])

	for _i in range(Globals.PLAYER_MAX_HEALTH):
		var health_indicator: TextureRect = _health_indicator_template.duplicate()
		health_indicator.visible = true
		_health_indicator_container.add_child(health_indicator)
		_health_indicators.push_back(health_indicator)

	Events.player_health_changed.connect(_on_player_health_changed)
	Events.game_over.connect(_on_game_over)
	_game_over.modulate = Color.TRANSPARENT

func _on_camera_moved(camera: Camera, _old_pos: Vector2, new_pos: Vector2) -> void:
	var subpixel_position: Vector2 = new_pos.round() - new_pos
	camera.global_position = new_pos.round()
	_viewport_container.material.set_shader_parameter("camera_offset", subpixel_position)

func _on_player_health_changed(new_health: int, _old_health: int) -> void:
	for i in range(0, _health_indicators.size()):
		_health_indicators[i].modulate.a = 1.0 if i + 1 <= new_health else 0.25

	if new_health <= 0:
		Events.game_over.emit()

func _on_game_over() -> void:
	_game.process_mode = Node.PROCESS_MODE_DISABLED

	# Show game over screen.
	await get_tree().create_timer(0.1).timeout
	await get_tree().create_tween().tween_property(_game_over, "modulate", Color.WHITE, 0.25).finished
	await get_tree().create_timer(1.0).timeout
	await get_tree().create_tween().tween_property(_game_over, "modulate", Color.TRANSPARENT, 0.25).finished
