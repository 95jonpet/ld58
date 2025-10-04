class_name GrappleArea
extends Area2D

signal apply_grapple(grappler: Area2D, delta: float)

const SALVAGE_COLLECT: AudioStream = preload("res://salvage/salvage_collect.wav")
const SALVAGE_COLLECT_MISS = preload("res://salvage/salvage_collect_miss.wav")

var _grappler: Area2D = null


func _process(delta: float) -> void:
	if not _grappler:
		return
	apply_grapple.emit(_grappler, delta)

func _on_area_entered(area: Area2D) -> void:
	_grappler = area
	AudioPlayer.play(SALVAGE_COLLECT)

func _on_area_exited(area: Area2D) -> void:
	if _grappler == area:
		_grappler = null
		AudioPlayer.play(SALVAGE_COLLECT_MISS)
