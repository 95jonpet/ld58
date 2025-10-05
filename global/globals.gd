extends Node

const PLAYER_MAX_HEALTH: int = 5

var player_position: Vector2
var player_health: int = PLAYER_MAX_HEALTH:
	set(value):
		var new_health: int = clampi(value, 0, PLAYER_MAX_HEALTH)
		Events.player_health_changed.emit(new_health, player_health)
		player_health = new_health

var salvage_count: int = 0:
	set(value):
		Events.salvage_collected.emit(value)
		salvage_count = value

func reset_session() -> void:
	player_health = PLAYER_MAX_HEALTH
	salvage_count = 0
