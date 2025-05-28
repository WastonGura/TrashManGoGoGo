class_name FlightAttackComponent extends AttackComponent

var player_id: Player
signal attack_over_for_pot

func attack(area):
	var is_hitbox = check_hitbox(area)
	var is_shield_box = check_shield_box(area)
	if is_hitbox or is_shield_box:
		var attacker = find_root(area)
		if attacker != player_id:
			var damage = get_ATK()
			if area.find_child("FlightComponent"):
				attacker.find_child("init").set_attack_maker_direction(area.flight_component.direction_vector.x)
			else:
				attacker.find_child("init").set_attack_maker_direction(area.scale.x)
			var health_component = attacker.get_node("component/HealthComponent")
			health_component.take_damage(damage, is_shield_box)
			emit_signal("attack_over")
			emit_signal("attack_over_for_pot")
		else:
			return
	else:
		return
