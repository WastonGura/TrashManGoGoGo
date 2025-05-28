extends Node

@export var flight_attack_component: FlightAttackComponent
@export var timer: Timer
@export var animation_player: AnimationPlayer
@onready var flash_audio_stream_player: AudioStreamPlayer = $FlashAudioStreamPlayer


func _ready() -> void:
	flash_start()

func flash_start():
	print("flash start")
	timer.start()
	flash_audio_stream_player.play()
	animation_player.play("FlashAnimation/Flash")

func _on_timer_timeout() -> void:
	queue_free()
	print("queue")

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Hitbox"):
		flight_attack_component.attack(area)
	elif area.is_in_group("Shieldbox"):
		flight_attack_component.attack(area)
