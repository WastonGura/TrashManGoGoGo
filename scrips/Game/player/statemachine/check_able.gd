extends Node2D

@export var player: Player
@export var player_control: PlayerControl


func _ready() -> void:
	player.healeth_component.connect("player_die", Callable(self,"set_die"))
	player.gravity_component.connect("touch_spike", Callable(self, "set_die"))
	player.gravity_component.connect("hp_area", Callable(self,"set_heal"))

func set_die():
	if not player_control.has_touch:
		player.healeth_component.set_HP(0)
		player_control.die = true
		player_control.has_touch = true

func set_heal():
	player_control.is_healing = true

func heal_player(delta):
	var up_hp = 20 * delta
	player.healeth_component.health_player(up_hp)
	player_control.is_healing = false

func _process(_delta: float) -> void:
	check_able()
	if player_control.is_healing:
		heal_player(_delta)

func check_can_control():
	if player_control.is_hurting or player_control.die:
		return false
	else:
		return true

func check_able():
	var EP = player.ep_component.get_EP()
	player_control.can_control = check_can_control()
	player_control.can_run = check_run()
	player_control.can_defend = check_defend(EP)
	player_control.can_jump = check_jump()
	check_tilemap_is_fly()
	player_control.can_skill = check_skill(EP)
	player_control.can_close_attack = check_close_attack()
	player_control.can_remote_attack = check_remote_attack()
	player_control.can_parry = check_parry()

func check_run():
	if player_control.can_control:
		return true
	else:
		return false

func check_tilemap_is_fly():
	if player_control.can_jump:
		# 遍历所有碰撞
		for i in range(player.get_slide_collision_count()):
			var col = player.get_slide_collision(i)
			if not col:
				continue
			var collider = col.get_collider()
			# 检查是否为 TileMapLayer
			if collider is TileMapLayer:
				var tilemap = collider
				var global_collision_point = col.get_position()
				var local_pos = tilemap.to_local(global_collision_point)
				var map_pos = tilemap.local_to_map(local_pos)
				var tile_data = tilemap.get_cell_tile_data(map_pos)
				# 检查 tile_data 是否存在且包含自定义属性
				if tile_data and tile_data.get_custom_data("Fly"):
					player_control.can_fly = true
				else:
					player_control.can_fly = false
			else:
				player_control.can_fly = false
	else:
		player_control.can_fly = false


func check_close_attack():
	if player_control.can_control and not player_control.is_action:
		if player_control.close_attack_locker <= 0.0:
			return true
		else:
			return false
	else:
		return false

func check_remote_attack():
	if player_control.can_control and not player_control.is_action:
		if player_control.has_pet:
			return true
		else:
			return false
	else:
		return false

func check_defend(current_EP):
	if player_control.can_control:
		if player_control.defend_locker == 0.0:
			if current_EP > 5:
				return true
			else:
				return false
		else:
			return false
	else:
		return false

func check_skill(current_EP):
	if player_control.can_control and player_control.skill_locker <= 0.0:
		if current_EP > 50:
			return true
		else:
			return false
	else:
		return false

func check_jump():
	if player_control.can_control:
		if player_control.jump_locker <= 0.0:
			return true
		else:
			return false
	else:
		return false

func check_parry():
	if player.ep_component.get_EP() > 40:
		return true
	else:
		return false

func _on_burn_state_entered() -> void:
	player_control.can_control = true

func _on_fly_state_entered() -> void:
	player_control.can_fly = true

func _on_fly_state_exited() -> void:
	player_control.can_fly = false
