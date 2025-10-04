class_name MissilePlatform
extends Node2D

const MISSILE_SPEED: float = 256.0
const MISSILE_SCENE: PackedScene = preload("res://missile/missile.tscn")

func _on_timer_timeout() -> void:
	_generate_missile()

func _generate_missile() -> void:
	var missile: Missile = MISSILE_SCENE.instantiate() as Missile
	add_sibling(missile)
	missile.position = position
	missile.rotation = global_position.direction_to(Globals.player_position).angle()
	missile.velocity = Vector2.from_angle(missile.rotation) * MISSILE_SPEED
