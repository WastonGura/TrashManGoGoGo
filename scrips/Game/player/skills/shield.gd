class_name Shield extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var shield_start_timer: Timer = $shield_start_timer
@onready var shield_start_timer_2: Timer = $shield_start_timer2


var start: bool = false
var continue_shield: bool = false
var end: bool = false
var restart: bool = false

func set_shield_direction(new_direction):
	scale.x = new_direction

func shield_state_entered() -> void:
	shield_start_timer.start()
	monitorable = true
	monitoring = true
	start = true
	continue_shield = true

func shield_state_exited() -> void:
	monitorable = false
	monitoring = false
	continue_shield = false
	end = true
	shield_start_timer_2.start()

func _on_shield_start_timer_2_timeout() -> void:
	start = false

func _on_shield_start_timer_timeout() -> void:
	end = false
