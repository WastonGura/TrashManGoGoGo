class_name TargetFlightComponent extends FlightComponent

## 旋转速度
@export var rotation_speed = 3.0
## 追踪目标
@export var target_node: Node

var target_position: Vector2

func _physics_process(delta):
	set_target_position(target_node.global_position)
	var target_rotation = get_angle_to(target_position)

	# 平滑旋转
	rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)

	# 计算移动方向
	var velocity = Vector2(speed, 0).rotated(rotation)

	# 移动飞行物
	find_root(self).global_position += velocity * delta

func set_target_position(node_position):
	target_position = node_position
