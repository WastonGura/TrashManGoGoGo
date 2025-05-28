extends Area2D

signal player_entered(body)

@export var trash_id:String = "glass"
@export var life_timer:float = 0

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Getbox"):
		emit_signal("player_entered", self)
