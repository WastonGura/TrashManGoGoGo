extends Node2D

@export var burn_duration: Timer
@export var area_control: Node2D
@export var player: Player
@export var player_control: PlayerControl

func _process(_delta: float) -> void:
	if not player_control.burn:
		if not player_control.is_burning:
			player.change_state("burn")
		else:
			return
	else:
		return

func _on_burn_state_entered() -> void:
	burn_duration.start()
	player_control.is_burning = true
	player.animation_tree.set("parameters/BlendTree/BurnAdd/add_amount", 1.0)
	print("reburn")
	area_control.close_hitbox()

func _on_burn_state_exited() -> void:
	print("has burn")
	player_control.burn = true
	player_control.is_burning = false
	player.animation_tree.set("parameters/BlendTree/BurnAdd/add_amount", 0.0)
	area_control.open_hitbox()

func _on_burn_duration_timeout() -> void:
	player.change_state("normal")
