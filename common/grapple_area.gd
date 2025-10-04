class_name GrappleArea
extends Area2D

signal apply_grapple(grappler: Area2D, delta: float)

var _grappler: Area2D = null


func _process(delta: float) -> void:
	if not _grappler:
		return
	apply_grapple.emit(_grappler, delta)

func _on_area_entered(area: Area2D) -> void:
	_grappler = area

func _on_area_exited(area: Area2D) -> void:
	if _grappler == area:
		_grappler = null
