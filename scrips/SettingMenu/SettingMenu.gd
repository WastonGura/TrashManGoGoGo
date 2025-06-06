extends Control

# 导入区
## 节点
@onready var bg: TextureRect = $BackGround/BG
@onready var container: Control = $Configs/Container

## 变量
var QuitMenuPath = preload("res://scenes/GameOver/QuitMenu.tscn")
var MainMenuPath = "res://scenes/MainMenu/MainMenu.tscn"
var LobbyMenuPath = "res://scenes/Lobby/LobbyMenu.tscn"

signal page_close

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

# 功能区
## 显示退出游戏确认窗口
func show_quit_menu() -> void:
	var quit_menu = QuitMenuPath.instantiate()
	container.add_child(quit_menu)

# 信号接收区
## 退出游戏按钮
func _on_quit_pressed() -> void:
	show_quit_menu()

func _on_home_pressed() -> void:
	emit_signal("page_close")
	self.queue_free()
