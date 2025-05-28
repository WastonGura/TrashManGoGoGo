extends Node2D

## 垃圾预制体的路径
@export var trash_prefab_path: Array[PackedScene]
## 生成垃圾的频率
@export var spawn_frequency:float = 1
## 垃圾的下落速度
@export var gravity = 100
## 垃圾的生命周期
@export var lifetime = 5

var trash_timer = 0
var viewport_rect : Rect2

signal trash_body_entered(body)

func _ready():
	# 获取视口大小
	viewport_rect = get_viewport_rect()

func _process(delta):
	trash_timer += delta
	if trash_timer >= 1 / spawn_frequency:
		spawn_trash()
		trash_timer = 0

func spawn_trash():
	# 实例化垃圾预制体
	var trash_instance = trash_prefab_path.pick_random().instantiate()
	var random_x = randf_range(viewport_rect.position.x + 200, viewport_rect.position.x + viewport_rect.size.x - 200)
	trash_instance.global_position = Vector2(random_x, viewport_rect.position.y - 300)
	# 将垃圾实例添加到场景中
	add_child(trash_instance)
	# 设置垃圾的下落和移除
	trash_instance.life_timer = lifetime # 在垃圾实例上设置计时器
	trash_instance.connect("player_entered", Callable(self, "_on_trash_body_entered")) # 修改信号连接方式

func _physics_process(delta):
	# 处理垃圾的下落和移除
	for trash_instance in get_tree().get_nodes_in_group("Trash"):
		var current_position = trash_instance.global_position
		current_position.y += gravity * delta #  直接用 gravity
		trash_instance.global_position = current_position # 设置回去

		trash_instance.life_timer -= delta # 减少剩余时间
		if trash_instance.life_timer <= 0 or trash_instance.global_position.y > viewport_rect.position.y + viewport_rect.size.y + 50:
			# 移除垃圾
			trash_instance.queue_free()

func _on_trash_body_entered(body):
	emit_signal("trash_body_entered", body)
