extends Control

# 导入区
## 节点
@onready var title = $"Panel/Title"
@onready var quit = $"Panel/Quit"
@onready var comfirm = $"Panel/Comfirm"


# 信号接收区
## 取消按钮
func _on_quit_pressed() -> void:
	queue_free()

## 确认按钮
func _on_comfirm_pressed() -> void:
	get_tree().quit()
