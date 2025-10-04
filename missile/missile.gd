class_name Missile
extends CharacterBody2D

const MISSILE_HIT: AudioStream = preload("res://missile/missile_hit.wav")

func _physics_process(delta: float) -> void:
	if move_and_collide(velocity * delta):
		AudioPlayer.play(MISSILE_HIT)
		ScreenShake.apply_shake(8)
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
