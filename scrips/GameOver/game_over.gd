extends Control

var mainmenu = "res://scenes/MainMenu/MainMenu.tscn"
@onready var title: Label = $BG/Title
@onready var confirm_sound_voice: AudioStreamPlayer = $confirm_sound_voice
@onready var move_sound_voice: AudioStreamPlayer = $move_sound_voice

var loser: Player
var player_P1: Player
var player_P2: Player

func set_result(player_id, player1, player2):
	loser = player_id
	player_P1 = player1
	player_P2 = player2

func _ready() -> void:
	set_title()

func set_title():
	if loser == player_P1:
		title.text = "恭喜红方获胜"
	else:
		title.text = "恭喜蓝方获胜"

func _on_comfirm_pressed() -> void:
	confirm_sound_voice.play()
	get_tree().change_scene_to_file(mainmenu)

func _on_quit_pressed() -> void:
	confirm_sound_voice.play()
	get_tree().quit()

func _on_comfirm_focus_entered() -> void:
	move_sound_voice.play()

func _on_quit_focus_entered() -> void:
	move_sound_voice.play()
