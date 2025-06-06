extends Node2D

@onready var flash_timer: Timer = $flash_timer
@onready var stars_timer: Timer = $stars_timer
@onready var angle_timer: Timer = $angle_timer
@onready var hip: Bone2D = $"../../sceneroot/Polygon/Skeleton2D/hip"

@export var player: Player
@export var player_control: PlayerControl
@export var persona: AudioStreamPlayer

# 星星预制件 (PackedScene)
@export var star_scene : PackedScene
@export var flash_scene: PackedScene
@export var angle_scene: PackedScene

# 生成星星的数量
@export var num_stars = 6

# 生成星星的半径
@export var spawn_radius = 50.0

signal skill_created(skill)

# 主技能键和组合技能键
var MAIN_ACTION = ""
var COMBO_ACTIONS = {
	"skill1": '',
	"skill2": '',
}

# 当前状态
var is_main_action_pressed = false
var current_combo_action = ""  # 只存储一个组合动作

# 信号
signal skill_triggered(skill_name)

func _ready() -> void:
	skill_triggered.connect(Callable(self,"_haddle_skill"))

func _set_action():
	# 主技能键和组合技能键
	MAIN_ACTION = player.skill_action
	COMBO_ACTIONS = {
		"skill1": player.get_action,
		"skill2": player.defend_action,
	}
	print(player.skill_action)


func _haddle_skill(skill_name):
	match skill_name:
		"basic_skill":
			player.state_chart.send_event("angle")
		player.get_action:
			player.state_chart.send_event("stars")
		player.defend_action:
			player.state_chart.send_event("flash")

func fire():
	persona.play()
	var angle_instance = angle_scene.instantiate()
	angle_instance.scale.x = hip.scale.x
	angle_instance.global_position = player.global_position + Vector2(50, -50) * hip.scale.normalized()
	var angle_direction = Vector2(1,0) * hip.scale.normalized()
	angle_instance.flight_component.set_direction_vector(angle_direction)
	angle_instance.flight_attack_component.set_ATK(player_control.AngleATK)
	angle_instance.flight_attack_component.player_id = player
	emit_signal("skill_created",angle_instance)

func flash():
	persona.play()
	var flash_instance = flash_scene.instantiate()
	flash_instance.scale.x = hip.scale.x
	flash_instance.global_position = player.global_position + Vector2(120, -120) * hip.scale.normalized()
	flash_instance.flight_attack_component.set_ATK(player_control.FlashATK)
	flash_instance.flight_attack_component.player_id = player
	emit_signal("skill_created",flash_instance)

func spark():
	persona.play()
	var angle_step = 360.0 / num_stars
	for i in range(num_stars):
		var star = star_scene.instantiate()
		var current_angle = angle_step * i
		# 设置初始位置（极坐标转换为直角坐标）
		var spawn_pos = Vector2.from_angle(deg_to_rad(current_angle)) * spawn_radius
		star.global_position = player.global_position + spawn_pos
		# 配置飞行组件
		star.flight_component.set_direction_degrees(current_angle)
		star.flight_attack_component.player_id = player
		# 添加到场景
		emit_signal("skill_created", star)

#func _input(InputEvent):
	#if player_control.can_skill:
		#if Input.is_action_pressed(player.skill_action):
			#print("skill")
			#if Input.is_action_pressed(player.get_action):
				#player.state_chart.send_event("stars")
			#elif Input.is_action_pressed(player.defend_action):
				#player.state_chart.send_event("flash")
			#else:
				#player.state_chart.send_event("angle")

func _input(event):
	if event.is_action_pressed(MAIN_ACTION):
		# 主动作按下
		is_main_action_pressed = true
		current_combo_action = ""  # 重置组合动作
	elif event.is_action_released(MAIN_ACTION):
		# 主动作释放，触发技能
		trigger_skill()
	
	# 检查组合动作
	if is_main_action_pressed:
		for action_name in COMBO_ACTIONS.values():
			if event.is_action_pressed(action_name):
				# 如果已经有组合动作，则忽略新的按键
				if current_combo_action == "":
					current_combo_action = action_name
			elif event.is_action_released(action_name):
				if current_combo_action == action_name:
					current_combo_action = ""

func trigger_skill():
	# 根据按下的组合动作决定技能
	var skill_name = "basic_skill"  # 默认技能
	
	if current_combo_action != "":
		# 使用当前组合动作作为技能名称
		skill_name = current_combo_action
	
	# 触发技能
	emit_signal("skill_triggered", skill_name)
	
	# 重置状态
	is_main_action_pressed = false
	current_combo_action = ""

func _on_flash_state_entered() -> void:
	flash_timer.start()
	player_control.is_skilling = true
	player_control.is_action = true
	flash()
	player.animation_tree["parameters/BlendTree/Skill/blend_position"] = Vector2(1.0, 0.0)
	player.animation_tree["parameters/BlendTree/SkillOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func _on_stars_state_entered() -> void:
	stars_timer.start()
	player_control.is_skilling = true
	player_control.is_action = true
	spark()
	player.animation_tree["parameters/BlendTree/Skill/blend_position"] = Vector2(-1.0, 0.0)
	player.animation_tree["parameters/BlendTree/SkillOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func _on_angle_state_entered() -> void:
	angle_timer.start()
	player_control.is_skilling = true
	player_control.is_action = true
	player.animation_tree["parameters/BlendTree/Skill/blend_position"] = Vector2(0.0, 1.0)
	player.animation_tree["parameters/BlendTree/SkillOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func _on_flash_state_exited() -> void:
	player_control.is_skilling = false
	player_control.skill_locker = 3.0
	var current_EP = player.ep_component.get_EP()
	var new_EP = current_EP - player_control.skill_cosume
	player.ep_component.set_EP(new_EP)
	player_control.is_action = false

func _on_stars_state_exited() -> void:
	player_control.is_skilling = false
	player_control.skill_locker = 3.0
	var current_EP = player.ep_component.get_EP()
	var new_EP = current_EP - player_control.skill_cosume
	player.ep_component.set_EP(new_EP)
	player_control.is_action = false

func _on_angle_state_exited() -> void:
	player_control.is_skilling = false
	player_control.skill_locker = 3.0
	var current_EP = player.ep_component.get_EP()
	var new_EP = current_EP - player_control.skill_cosume
	player.ep_component.set_EP(new_EP)
	player_control.is_action = false

func _on_flash_timer_timeout() -> void:
	player.change_state("idle")

func _on_stars_timer_timeout() -> void:
	player.change_state("idle")

func _on_angle_timer_timeout() -> void:
	fire()
	player.change_state("idle")
