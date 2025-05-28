extends Node2D

@export var player:Player
@export var player_control: PlayerControl
@export var hurt_timer:Timer
@export var die_timer: Timer
@onready var hurt_audio_stream_player: AudioStreamPlayer = $HurtAudioStreamPlayer
@onready var die_audio_stream_player: AudioStreamPlayer = $DieAudioStreamPlayer

var attack_maker_direction
var hurt_power: float
var fade_power: float

signal game_over(player_id)

func _ready() -> void:
	player.healeth_component.connect("damage_over", Callable(self, "hurt"))

func _process(_delta: float) -> void:
	if player_control.die:
		die()

func set_attack_maker_direction(the_attack_maker_direciton):
	attack_maker_direction = the_attack_maker_direciton

func die():
	player.change_state("die")

func burn():
	player_control.burn = false
	reburn()
	set_create_position()
	player_control.die = false

func reburn():
	player_control.has_touch = false
	player_control.has_pet = true
	player.defend_component.pot_HP = 100
	player.ep_component.set_EP(20)
	player.healeth_component.set_HP(100)

func set_create_position():
	var created_position = player_control.create_position.pick_random()
	player.global_position = created_position

func hurt(damage, is_shield):
	if not is_shield:
		player.change_state("hurt")
		hurt_power = damage * player_control.HURTFORCE
		fade_power = hurt_power / 0.5

func _on_hurt_state_entered() -> void:
	hurt_timer.start()
	hurt_audio_stream_player.play()
	player_control.is_hurting = true

func _on_hurt_state_exited() -> void:
	player_control.is_hurting = false

func _on_hurt_state_processing(delta: float) -> void:
	if hurt_power > 0:
		hurt_power = max(0, hurt_power - delta * fade_power)
	player.velocity.x = hurt_power * attack_maker_direction

func _on_die_state_entered() -> void:
	die_audio_stream_player.play()
	player.healeth_component.current_lives = player.healeth_component.current_lives - 1
	if player.healeth_component.current_lives > 0:
		die_timer.start()
	else:
		emit_signal("game_over", player)

func _on_die_timer_timeout() -> void:
	player.change_state("idle")

func _on_hurt_timer_timeout() -> void:
	player.change_state("idle")

func _on_die_state_exited() -> void:
	burn()
