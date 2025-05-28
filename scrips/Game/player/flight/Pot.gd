class_name Pot extends Area2D

@export var flight_component: FlightComponent
@export var flight_attack_component: FlightAttackComponent

func _ready() -> void:
	flight_attack_component.connect("attack_over_for_pot", Callable(flight_component, 'destroy'))

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Hitbox"):
		flight_attack_component.attack(area)
	elif area.is_in_group("Shieldbox"):
		flight_attack_component.attack(area)
	elif area.is_in_group("Pot"):
		flight_component.destroy()
	elif area.is_in_group("Wall"):
		flight_component.destroy()
