extends Node

@warning_ignore("unused_signal")
signal camera_moved(camera: Camera, old_global_pos: Vector2, new_global_pos: Vector2)

@warning_ignore("unused_signal")
signal player_health_changed(new_health: int, old_health: int)

@warning_ignore("unused_signal")
signal salvage_collected(salvage_count: int)

@warning_ignore("unused_signal")
signal game_over()
