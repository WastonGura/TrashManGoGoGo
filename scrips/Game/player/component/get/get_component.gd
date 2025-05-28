class_name GetComponent extends Node2D


func handle_get(area):
	if area.is_in_group("Trash"):
		area.queue_free()
		return true
	else:
		return false
