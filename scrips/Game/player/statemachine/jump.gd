extends Node2D

@export var player: Player
@export var player_control: PlayerControl

@onready var land_timer: Timer = $land_timer


func _process(_delta: float) -> void:
	handle_input()

func handle_input():
	if player_control.can_jump:
		if Input.is_action_just_pressed(player.jump_action):
			player.change_state("jump")
		else:
			if player.velocity.y < 0 and not player.is_on_floor():
				player.change_state("rise")
			elif player.velocity.y > 0 and not player.is_on_floor():
				player.change_state("fall")
			elif player_control.is_flying and player.is_on_floor():
				player.change_state("land")
	else:
		if player.velocity.y < 0 and not player.is_on_floor():
			player.change_state("rise")
		elif player.velocity.y > 0 and not player.is_on_floor():
			player.change_state("fall")
		elif player_control.is_flying and player.is_on_floor():
			player.change_state("land")

func _on_jump_state_entered() -> void:
	player_control.jump = true
	player_control.jump_locker = 1
	player.velocity.y = -player_control.jump_force

func _on_jump_state_exited() -> void:
	player_control.jump = false

func _on_rise_state_entered() -> void:
	player_control.is_flying = true
	player.set_collision_mask_value(8,false)
	player.animation_tree["parameters/BlendTree/BaseState/Fly/blend_position"] = -1

func _on_rise_state_exited() -> void:
	player.set_collision_mask_value(8,true)

func _on_fall_state_entered() -> void:
	player_control.is_flying = true
	player.animation_tree["parameters/BlendTree/BaseState/Fly/blend_position"] = 1

func _on_fall_state_exited() -> void:
	pass

func _on_land_state_entered() -> void:
	player_control.is_flying = false
	player_control.land = true
	land_timer.start()

func _on_land_state_exited() -> void:
	player_control.land = false

func _on_land_timer_timeout() -> void:
	player.change_state("idle")
