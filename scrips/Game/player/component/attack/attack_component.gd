class_name AttackComponent extends Node2D

@export var ATK = 10

signal attack_over

func get_ATK():
	return ATK

func set_ATK(new_ATK):
	ATK = new_ATK

func attack(area):
	var is_hitbox = check_hitbox(area)
	var is_shield_box = check_shield_box(area)
	if is_hitbox or is_shield_box:
		var attacker = find_root(area)
		if attacker != find_root(self):
			var damage = get_ATK()
			print(area.scale.x)
			attacker.find_child("init").set_attack_maker_direction(find_root(self).scale.x)
			var health_component = attacker.get_node("component/HealthComponent")
			health_component.take_damage(damage, is_shield_box)
			emit_signal("attack_over")
		else:
			return
	else:
		return

func check_hitbox(area):
	if area.is_in_group("Hitbox"):
		return true
	else:
		return false

func check_shield_box(area):
	if area.is_in_group("Shieldbox"):
		return true
	else:
		return false

func find_root(node):
	var parent = node.get_parent()
	if parent == null:
		return node
	if parent is Player:
		return parent
	else:
		return find_root(parent)
