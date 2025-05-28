extends Node2D

@onready var hip: Bone2D = $"../../sceneroot/Polygon/Skeleton2D/hip"
@onready var area: Node2D = $"../../Area"

@export var player: Player
@export var player_control: PlayerControl


func set_player_direction():
	player.direction.x = Input.get_axis(player.left_run_action, player.right_run_action)
	var normal_dir_x = player.direction.normalized().x
	if normal_dir_x != 0 :
		hip.scale.x = normal_dir_x
		area.scale.x = normal_dir_x

func run():
	player.velocity.x = player_control.run_speed * player.direction.x

func _physics_process(_delta: float) -> void:
	if not player_control.continue_defend:
		set_player_direction()
	handle_input()
	if player_control.can_run:
		run()
	else:
		player.velocity.x = 0.0

func handle_input():
	if player_control.can_run and abs(player.direction.x) > 0:
		player.change_state("run")
	elif player_control.is_running and abs(player.direction.x) == 0:
		player.change_state("idle")

func _on_run_state_entered() -> void:
	player_control.is_running = true

func _on_run_state_exited() -> void:
	player_control.is_running = false
