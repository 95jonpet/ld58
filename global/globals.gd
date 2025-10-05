extends Node

const PLAYER_MAX_HEALTH: int = 5

var player_position: Vector2
var player_health: int = PLAYER_MAX_HEALTH:
	set(value):
		var new_health: int = clampi(value, 0, PLAYER_MAX_HEALTH)
		Events.player_health_changed.emit(new_health, player_health)
		player_health = new_health
