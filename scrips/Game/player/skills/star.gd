extends Area2D

@onready var stars_audio_stream_player: AudioStreamPlayer = $StarsAudioStreamPlayer

@export var animation_player: AnimationPlayer
@export var flight_component: FlightComponent
@export var flight_attack_component: FlightAttackComponent

func _ready() -> void:
	start()

func start() -> void:
	animation_player.play("StarAnimation/Star")
	stars_audio_stream_player.play()

func _process(_delta: float) -> void:
	flight_attack_component.connect("attack_over", Callable(flight_component, 'destroy'))

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Hitbox"):
		flight_attack_component.attack(area)
	elif area.is_in_group("Shieldbox"):
		flight_attack_component.attack(area)
	elif area.is_in_group("Wall"):
		flight_component.destroy()
