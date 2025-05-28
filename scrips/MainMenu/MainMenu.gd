extends Control

# 导入区
## 节点
@export var confirm_sound_voice: AudioStreamPlayer
@export var move_sound_voice: AudioStreamPlayer
@onready var bg = $"BG"

## 变量
var GamePath = preload("res://scenes/Game/Game.tscn")
var SettingMenuPath = preload("res://scenes/Setting/SettingMenu.tscn")
var QuitMenuPath = preload("res://scenes/GameOver/QuitMenu.tscn")

# 功能区
## 弹出退出游戏确认窗口
func ShowCloseGameMenu():
	var quit_menu = QuitMenuPath.instantiate()
	bg.add_child(quit_menu)

# 信号接收区
## 退出游戏按钮
func _on_quit_pressed() -> void:
	ShowCloseGameMenu()

func _on_双人对决_mouse_entered() -> void:
	move_sound_voice.play()

func _on_单人对战_mouse_entered() -> void:
	move_sound_voice.play()

func _on_系统设置_mouse_entered() -> void:
	move_sound_voice.play()

func _on_双人对决_pressed() -> void:
	confirm_sound_voice.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_packed(GamePath)

func _on_单人对战_pressed() -> void:
	pass # Replace with function body.

func _on_系统设置_pressed() -> void:
	confirm_sound_voice.play()
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_packed(SettingMenuPath)
