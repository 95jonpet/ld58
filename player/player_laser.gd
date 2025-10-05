class_name PlayerLaser
extends CharacterBody2D


func _physics_process(delta: float) -> void:
	if move_and_collide(velocity * delta):
		ScreenShake.apply_shake(5)
		queue_free()
