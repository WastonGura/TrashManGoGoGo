extends Node2D

@export var player: Player
@export var player_control: PlayerControl
@export var sound: AudioStreamPlayer

@onready var defend_start_timer: Timer = $defend_start_timer
@onready var shield_area: Area2D = $"../../shield_container/ShieldArea"
@onready var defend_start_timer_2: Timer = $defend_start_timer2
@onready var hip: Bone2D = $"../../sceneroot/Polygon/Skeleton2D/hip"
@onready var defend_area: Area2D = $"../../Area/DefendArea"

func _process(_delta: float) -> void:
	handle_input()

func handle_input():
	if player_control.can_defend:
		if Input.is_action_pressed(player.defend_action):
			player.change_state("defend")
		elif Input.is_action_just_released(player.defend_action):
			player.change_state("idle")
	else:
		if player_control.continue_defend:
			player.change_state("idle")
		else:
			return

func _on_defend_state_entered() -> void:
	defend_area.monitorable = true
	defend_area.monitoring = true
	sound.play()
	shield_area.set_shield_direction(hip.scale.x)
	if player_control.has_pet:
		shield_area.shield_state_entered()
	defend_start_timer.start()
	player_control.start_defend = true
	player_control.continue_defend = true

func _on_defend_state_exited() -> void:
	sound.stop()
	defend_area.monitorable = false
	defend_area.monitoring = false
	if player_control.has_pet:
		shield_area.shield_state_exited()
	player_control.continue_defend = false
	player_control.end_defend = true
	player_control.defend_locker = 1.5
	defend_start_timer_2.start()

func _on_defend_state_processing(delta: float) -> void:
	var current_EP = player.ep_component.get_EP()
	var new_EP = current_EP - delta * player_control.defend_cosume
	player.ep_component.set_EP(new_EP)

func _on_defend_start_timer_timeout() -> void:
	player_control.start_defend = false

func _on_defend_start_timer_2_timeout() -> void:
	player_control.end_defend = false
