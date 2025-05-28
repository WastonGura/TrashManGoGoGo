class_name Angle extends Area2D

@export var flight_attack_component: FlightAttackComponent
@export var flight_component: FlightComponent
@export var animation_player: AnimationPlayer
@onready var angle_audio_stream_player: AudioStreamPlayer = $AngleAudioStreamPlayer

func _ready() -> void:
	flight_attack_component.connect("attack_over", Callable(flight_component, 'destroy'))
	start()

func start() -> void:
	animation_player.play("AngleAnimation/Angle")
	angle_audio_stream_player.play()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Hitbox"):
		flight_attack_component.attack(area)
	elif area.is_in_group("Shieldbox"):
		flight_attack_component.attack(area)
	elif area.is_in_group("Wall"):
		flight_component.destroy()
