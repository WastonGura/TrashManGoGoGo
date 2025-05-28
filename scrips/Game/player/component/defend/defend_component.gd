class_name DefendComponent extends Node2D

@export var pot_HP: int = 100
@export var DEF = 0

func get_DEF():
	return max(DEF,0)

func set_DEF(new_DEF):
	DEF = new_DEF

func defend(damage):
	pot_HP -= damage
	var new_damage = damage - get_DEF()
	new_damage = max(new_damage, 1)
	return new_damage
