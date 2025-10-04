class_name Main
extends Node

@onready var _viewport_container: SubViewportContainer = $SubViewportContainer


func _on_camera_moved(camera: Camera, _old_pos: Vector2, new_pos: Vector2) -> void:
	var subpixel_position: Vector2 = new_pos.round() - new_pos
	camera.global_position = new_pos.round()
	_viewport_container.material.set_shader_parameter("camera_offset", subpixel_position)
