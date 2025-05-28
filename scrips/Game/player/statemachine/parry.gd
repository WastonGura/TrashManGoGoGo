extends Node2D

@export var player:Player
@export var player_control: PlayerControl
@export var area: Node2D
@export var animation_player: AnimationPlayer
@export var kawei_eye: Sprite2D
@export var kawei_gameuse: AudioStreamPlayer

@onready var parry_timer: Timer = $parry_timer
@onready var kawei_timer: Timer = $kawei_timer
@onready var parry_area: Area2D = $"../../Area/ParryArea"

var has_kawei: bool

func _process(_delta: float) -> void:
	handle_input()

func kawei():
	has_kawei = true
	var current_EP = player.ep_component.get_EP()
	var new_EP = current_EP + player_control.parry_get
	player.ep_component.set_EP(new_EP)
	kawei_eye.show()
	animation_player.play("kawei")
	kawei_timer.start()
	kawei_gameuse.play()

func handle_input():
	if player_control.can_parry:
		if Input.is_action_just_pressed(player.parry_action):
			player.change_state("parry")

func _on_parry_state_entered() -> void:
	area.close_hitbox()
	parry_area.monitorable = true
	parry_area.monitoring = true
	player.animation_tree["parameters/BlendTree/ParryOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	parry_timer.start()
	var current_EP = player.ep_component.get_EP()
	var new_EP = current_EP - player_control.parry_cosume
	player.ep_component.set_EP(new_EP)

func _on_parry_state_exited() -> void:
	parry_area.monitorable = false
	parry_area.monitoring = false
	if not has_kawei:
		area.open_hitbox()

func _on_parry_area_area_entered(hurt_area: Area2D) -> void:
	if hurt_area.is_in_group("Hurtbox"):
		if find_root(hurt_area) != find_root(self): 
			kawei()

func _on_parry_timer_timeout() -> void:
	player.change_state("hust")

func _on_kawei_timer_timeout() -> void:
	kawei_eye.hide()
	has_kawei = false
	area.open_hitbox()

func find_root(node):
	var parent = node.get_parent()
	if parent == null:
		return node
	if parent is Player:
		return parent
	else:
		return find_root(parent)
