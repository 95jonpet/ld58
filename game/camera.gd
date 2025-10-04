class_name Camera
extends Camera2D


@export var speed: float = 5.0

@onready var target_position: Vector2 = global_position

# The smooth camera rounds global_position, so its raw value must be stored separately.
@onready var current_position: Vector2 = global_position


func _process(delta: float) -> void:
	var old_position := current_position

	current_position = current_position.lerp(target_position, delta * speed)

	global_position = current_position
	if global_position != old_position:
		Events.camera_moved.emit(self, old_position, global_position)
