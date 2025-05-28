class_name FlightComponent extends Node2D

## 飞行速度（像素/秒）
@export var speed: float = 200.0
## 重力（Y轴方向的附加速度，像素/秒）
@export var gravity_force: float = 0.0
## 生命周期（秒）
@export var lifetime_timer: float = 0.0

var current_time: float = 0.0
var direction_vector: Vector2 = Vector2.RIGHT  # 标准化方向向量

func _process(delta: float) -> void:
	if current_time < lifetime_timer:
		current_time += delta
	else:
		destroy()
	move(delta)

func find_root(node):
	var parent = node.get_parent()
	return parent if parent is Area2D or parent == null else find_root(parent)

## 设置移动方向为指定角度（度数制）
func set_direction_degrees(degrees: float) -> void:
	direction_vector = Vector2.from_angle(deg_to_rad(degrees)).normalized()

## 设置移动方向为任意向量（自动标准化）
func set_direction_vector(direction: Vector2) -> void:
	direction_vector = direction.normalized()

## 设置水平方向（兼容旧代码：1=右，-1=左）
func set_direction(new_direction: int) -> void:
	direction_vector = Vector2(sign(new_direction), 0.0)

func move(delta):
	var root = find_root(self)
	# 应用主方向移动
	root.global_position += direction_vector * speed * delta
	# 应用重力效果
	root.global_position.y += gravity_force * delta

func destroy():
	var root = find_root(self)
	if is_instance_valid(root):
		root.queue_free()
		print(root)
		print("destroy")
