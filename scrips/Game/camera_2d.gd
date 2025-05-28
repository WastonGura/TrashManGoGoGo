extends Camera2D

# 玩家节点变量
@export var player1: Player
@export var player2: Player

# 边距变量，用于控制留白
@export var margin = 50  # 可根据需要调整

# 缩放限制
@export var min_zoom = 0.65  # 最小缩放级别
@export var max_zoom = 1.2  # 最大缩放级别

# 地图边界
var map_rect: Rect2

func _ready():
	if player1 == null or player2 == null:
		printerr("Player nodes not found.  Make sure the paths are correct.")
		set_process(false) # Stop processing if players not found.

	# 设置相机的平滑移动
	set_process(true) # 确保 _process 函数被调用
	position_smoothing_enabled = true # 启用相机的平滑移动
	position_smoothing_speed = 5.0 # 调整平滑速度。  这里没有问题，但为了更严谨，可以放在if语句中。


func _process(_delta):
	if player1 == null or player2 == null:
		return  # Exit if players are invalid

	# 计算玩家的最小和最大坐标
	var min_x = min(player1.position.x, player2.position.x)
	var max_x = max(player1.position.x, player2.position.x)
	var min_y = min(player1.position.y, player2.position.y)
	var max_y = max(player1.position.y, player2.position.y)

	# 增加边距
	min_x -= margin
	max_x += margin
	min_y -= margin
	max_y += margin

	# 计算包含两个玩家的矩形的中心点
	var target_position = Vector2(
		(min_x + max_x) / 2,
		(min_y + max_y) / 2
	)
	
	# 获取当前视口的大小
	var viewport_size = get_viewport_rect().size
	
	 # 计算包含玩家的矩形的尺寸
	var required_width = max_x - min_x
	var required_height = max_y - min_y

	## 为了确保两个玩家都在视野内，我们需要计算一个合适的缩放级别。
	## 我们需要同时考虑宽度和高度的限制。
	var zoom_x = viewport_size.x / required_width
	var zoom_y = viewport_size.y / required_height
	
	## 使用较小的缩放级别，以确保两个玩家都适合在视口中
	var target_zoom = min(zoom_x, zoom_y)
	
	## 限制缩放级别，以防止它变得过大或过小。
	target_zoom = clamp(target_zoom, min_zoom, max_zoom)

	## 应用计算出的位置和缩放
	global_position = target_position
	zoom = Vector2(target_zoom, target_zoom)
