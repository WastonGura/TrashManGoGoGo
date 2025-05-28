extends Node


var scale_factor = 1.0


func _ready() -> void:
	update_scale_factor()


func update_scale_factor() -> void:
	var window_size = get_window().size
	scale_factor = window_size.x / 1920.0
