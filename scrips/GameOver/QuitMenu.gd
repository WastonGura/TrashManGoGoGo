extends Control

# 导入区
## 节点
@onready var title: Label = $BG/Title
@onready var comfirm: Button = $BG/Comfirm
@onready var quit: Button = $BG/Quit


# 信号接收区
## 取消按钮
func _on_quit_pressed() -> void:
	queue_free()

## 确认按钮
func _on_comfirm_pressed() -> void:
	get_tree().quit()
