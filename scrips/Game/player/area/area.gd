extends Node2D


@export var player: Player


@onready var hurtbox: Area2D = $"../Area/Hurtbox"
@onready var defend_area: Area2D = $"../Area/DefendArea"
@onready var hitbox: Area2D = $"../Area/Hitbox"
@onready var get_area: Area2D = $"../Area/GetArea"
@onready var parry_area: Area2D = $"../Area/ParryArea"

func find_root(node):
	var parent = node.get_parent()
	if parent == null:
		return node
	if parent is Player:
		return parent
	else:
		return find_root(parent)

func open_hurtbox():
	hurtbox.monitorable = true
	hurtbox.monitoring = true

func close_hurtbox():
	hurtbox.monitorable = false
	hurtbox.monitoring = false

func open_hitbox():
	hitbox.monitorable = true
	hitbox.monitoring = true

func close_hitbox():
	hitbox.monitorable = false
	hitbox.monitoring = false

func open_defend_area():
	defend_area.monitorable = true
	defend_area.monitoring = true

func close_defend_area():
	defend_area.monitorable = false
	defend_area.monitoring = false

func open_get_area():
	get_area.monitorable = true
	get_area.monitoring = true

func close_get_area():
	get_area.monitorable = false
	get_area.monitoring = false

func open_parry_area():
	parry_area.monitorable = true
	parry_area.monitoring = true

func close_parry_area():
	parry_area.monitorable = false
	parry_area.monitoring = false

func _on_hurtbox_area_entered(area: Area2D) -> void:
	player.attack_component.attack(area)

func _on_get_area_area_entered(area: Area2D) -> void:
	if player.get_component.handle_get(area):
		player.ep_component.update_ep_by_trash()
