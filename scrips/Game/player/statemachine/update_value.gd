extends Node2D

@onready var fly_timer: Timer = $fly_timer

@export var player: Player
@export var player_control: PlayerControl

var last_has_pet:bool = true

func _process(delta: float) -> void:
	update_value(delta)

func update_value(delta):
	update_locker(delta)
	pet_atk()
	shield_def()
	gravity_fly()
	run_speed()

func update_locker(delta):
	if player_control.skill_locker > 0:
		player_control.skill_locker -= delta
		player_control.skill_locker = max(0, player_control.skill_locker)
	if player_control.close_attack_locker > 0:
		player_control.close_attack_locker -= delta
		player_control.close_attack_locker = max(0,player_control.close_attack_locker)
	if player_control.defend_locker > 0:
		player_control.defend_locker -= delta
		player_control.defend_locker = max(0, player_control.defend_locker)
	if player_control.jump_locker > 0:
		if player.is_on_floor():
			player_control.jump_locker = 0
		else:
			player_control.jump_locker -= delta
			player_control.jump_locker = max(0,player_control.jump_locker)

func pet_atk():
	if player_control.has_pet and not last_has_pet:
		var current_atk = player.attack_component.get_ATK()
		var new_atk = current_atk + 5
		player.attack_component.set_ATK(new_atk)
		last_has_pet = true
	if not player_control.has_pet and last_has_pet:
		var current_atk = player.attack_component.get_ATK()
		var new_atk = current_atk - 5
		player.attack_component.set_ATK(new_atk)
		last_has_pet = false

func shield_def():
	if player_control.continue_defend:
		player.defend_component.DEF += 40
	if not player_control.has_pet:
		player.defend_component.DEF -= 20

func run_speed():
	if player_control.is_flying:
		player_control.run_speed = player_control.FLYRUNSPEED
	elif player_control.continue_defend:
		player_control.run_speed = player_control.DEFENDRUNSPEED
	else:
		player_control.run_speed = player_control.RUNSPEED

func gravity_fly():
	if player_control.is_skilling:
		player_control.gravity = player_control.SKILLGRAVITY
	else:
		if player_control.can_fly:
			player_control.jump_force = player_control.FLYPFORCE
			player_control.gravity = player_control.FLYGRAVITY
			fly_timer.start()
		else:
			player_control.jump_force = player_control.JUMPFORCE
			player_control.gravity = player_control.GRAVITY

func _on_fly_timer_timeout() -> void:
	player_control.gravity = player_control.GRAVITY
	player_control.jump_force = player_control.JUMPFORCE
