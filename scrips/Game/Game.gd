extends Node2D

@export var player_P1: Player
@export var player_P2: Player
@export var flight_container: Node2D
@export var canvas_layer: CanvasLayer
@export var game_over_scene: PackedScene

@onready var bgm: AudioStreamPlayer = $BGM


var HP_P1
var EP_P1
var HP_P2
var EP_P2

func _ready() -> void:
	var player: Array = [player_P1, player_P2]
	for i in player:
		var remote_attack = i.find_child("remote_attack")
		var skill = i.find_child("skill")
		var init = i.find_child("init")
		remote_attack.connect("pet_created", Callable(self, 'handle_flight_instance'))
		skill.connect("skill_created", Callable(self, "handle_flight_instance"))
		init.connect("game_over", Callable(self, "game_over"))

func _process(_delta: float) -> void:
	HP_P1 = player_P1.healeth_component.get_HP()
	EP_P1 = player_P1.ep_component.get_EP()
	HP_P2 = player_P2.healeth_component.get_HP()
	EP_P2 = player_P2.ep_component.get_EP()
	canvas_layer.set_player_hp(HP_P1, player_P1.player_id)
	canvas_layer.set_player_hp(HP_P2, player_P2.player_id)
	canvas_layer.set_player_ep(EP_P1, player_P1.player_id)
	canvas_layer.set_player_ep(EP_P2, player_P2.player_id)

func handle_flight_instance(instance):
	flight_container.add_child(instance)
	instance.show()

func game_over(player_id):
	bgm.stop()
	var game_over_instance = game_over_scene.instantiate()
	game_over_instance.set_result(player_id, player_P1, player_P2)
	canvas_layer.add_child(game_over_instance)
