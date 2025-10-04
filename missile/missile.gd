class_name Missile
extends CharacterBody2D

func _physics_process(delta: float) -> void:
	if move_and_collide(velocity * delta):
		ScreenShake.apply_shake(8)
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
