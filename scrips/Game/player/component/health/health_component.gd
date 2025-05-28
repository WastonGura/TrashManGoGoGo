class_name HealthComponent extends Node2D

@export var HP = 100
@export var current_lives: int = 3

signal damage_over(damage, is_shield)
signal player_die
signal get_hurt(damage)

func _process(_delta: float) -> void:
	check_death()

func get_HP():
	return HP

func set_HP(new_HP):
	HP = new_HP

func health_player(value):
	var current_hp = get_HP()
	var new_hp = current_hp + value
	set_HP(new_hp)

func take_damage(damage,is_shield_box):
	var parent = get_parent()
	if is_shield_box:
		if parent.has_node("component/DefendComponent"):
			var defend_component = parent.get_node("component/DefendComponent")
			damage = defend_component.defend(damage)
	else:
		emit_signal("get_hurt")
	var new_HP = get_HP() - damage
	new_HP = max(new_HP, 0)
	set_HP(new_HP)
	emit_signal("damage_over", damage, is_shield_box)

func check_death():
	var current_HP = get_HP()
	if current_HP <= 0:
		emit_signal("player_die")
	else:
		return
