extends Control

# 导入区
## 节点
@export var confirm_sound_voice: AudioStream
@export var move_sound_voice: AudioStream
@export var bgm:AudioStream

@onready var bg: TextureRect = $BackGroud/BG
@onready var back_groud_layer: CanvasLayer = $BackGroud
@onready var configs_layer: CanvasLayer = $Configs
@onready var page_container: CanvasLayer = $PageContainer

## 变量
@export var SettingMenuScene:PackedScene
@export var GameScene:PackedScene
@export var QuitMenuScene:PackedScene

func _ready() -> void:
	AudioManager.play_music(bgm)
	back_groud_layer.show()
	configs_layer.show()
	page_container.hide()

# 功能区
## 弹出退出游戏确认窗口
func ShowCloseGameMenu():
	var quit_menu = QuitMenuScene.instantiate()
	bg.add_child(quit_menu)

# 信号接收区
## 退出游戏按钮
func _on_quit_pressed() -> void:
	ShowCloseGameMenu()

func _on_双人对决_mouse_entered() -> void:
	AudioManager.play_sfx(move_sound_voice)

func _on_系统设置_mouse_entered() -> void:
	AudioManager.play_sfx(move_sound_voice)

func _on_双人对决_pressed() -> void:
	AudioManager.play_sfx(confirm_sound_voice)
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_packed(GameScene)

func _on_系统设置_pressed() -> void:
	AudioManager.play_sfx(confirm_sound_voice)
	var setting_page = SettingMenuScene.instantiate()
	add_child(setting_page)
	configs_layer.hide()
	back_groud_layer.hide()
	page_container.show()
	setting_page.page_close.connect(Callable(self,"_on_page_close"))

func _on_page_close() -> void:
	page_container.hide()
	configs_layer.show()
	back_groud_layer.show()
