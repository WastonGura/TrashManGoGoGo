extends Node2D

@export var player: Player
@export var player_control: PlayerControl
@export var area: Node2D


func _process(_delta: float) -> void:
	handle_input()

func handle_input():
	if player_control.can_control:
		if Input.is_action_pressed(player.get_action):
			player.change_state("get")
		elif Input.is_action_just_released(player.get_action):
			player.change_state("idle")

func _on_get_state_entered() -> void:
	area.open_get_area()
	player.animation_tree["parameters/BlendTree/GetBlend/blend_amount"] = 1.0

func _on_get_state_exited() -> void:
	area.close_get_area()
	player.animation_tree["parameters/BlendTree/GetBlend/blend_amount"] = 0.0
