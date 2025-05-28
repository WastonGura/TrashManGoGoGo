extends Control

# 导入区
## 节点
@onready var bg = $BG
@onready var p1_character = $BG/P1/SelectionPanelP1/CharacterDisplay
@onready var p2_character = $BG/P2/SelectionPanelP2/CharacterDisplay
@onready var animation_player: AnimationPlayer = $BG/AnimationPlayer
@onready var p_1_label: Label = $BG/P1Label
@onready var p_2_label: Label = $BG/P2Label

## 变量
var QuitMenuPath = preload("res://scenes/GameOver/QuitMenu.tscn")
var SettingMenuPath = preload("res://scenes/Setting/SettingMenu.tscn")
var MainMenuPath = "res://scenes/MainMenu/MainMenu.tscn"
var GamePath = preload("res://scenes/Game/Game.tscn")
var character_scenes = {
	"normal": preload("res://scenes/characters/TrashManCard/normalcard.tscn"),
	"unrecycle": preload("res://scenes/characters/TrashManCard/unrecyclecard.tscn"),
	"recycle": preload("res://scenes/characters/TrashManCard/recyclecard.tscn"),
	"harm": preload("res://scenes/characters/TrashManCard/harmcard.tscn"),
	"kitchen": preload("res://scenes/characters/TrashManCard/kitchencard.tscn"),
}
var character_pool = []

# 选择状态
var p1_current_index := 0
var p2_current_index := 0
var p1_ready := false
var p2_ready := false
var characters = ["normal", "unrecycle", "recycle", "harm", "kitchen"]
var current_characters := {
	1: characters[0], 
	2: characters[0]
}
var is_switching := false

# 动画参数
const SWITCH_DURATION := 0.8
const MOVE_OFFSET := Vector2(600, 0)
const ENTER_POSITION = Vector2(800, 200)    # 进场起始位置（屏幕右侧外）
const TARGET_POSITION = Vector2(400, 200)   # 目标中心位置
const EXIT_POSITION = Vector2(-200, 200)    # 退场目标位置
const PLAYER_OFFSET = Vector2(300, 0)       # 双玩家之间的水平间距

func _ready():
	for key in character_scenes:
		ResourceLoader.load_threaded_request(character_scenes[key].resource_path)
	init_characters()
	p_1_label.text = "选择角色"
	p_2_label.text = "选择角色"
	p_1_label.visible = true
	p_2_label.visible = true
	p_1_label.add_theme_font_size_override("font_size", 35*GlobalSetting.scale_factor)
	p_2_label.add_theme_font_size_override("font_size", 35*GlobalSetting.scale_factor)

# 初始化角色显示
func init_characters():
	update_character_display(p1_character, current_characters[1])
	update_character_display(p2_character, current_characters[2])

func get_character_from_pool(type: String):
	for obj in character_pool:
		if obj.type == type and not obj.is_inside_tree():
			return obj
	var new_char = character_scenes[type].instantiate()
	new_char.type = type
	character_pool.append(new_char)
	return new_char


# 更新角色显示（含骨骼动画控制）
func update_character_display(target_node: Node, character_name: String):
	if is_switching: 
		return
	is_switching = true
	
	# 移除旧角色
	if target_node.get_child_count() > 0:
		var old_char = target_node.get_child(0)
		play_exit_animation(old_char)
		# 添加超时保护
		var timeout = 0.0
		while old_char.is_inside_tree() and timeout < SWITCH_DURATION * 2:
			await get_tree().process_frame
			timeout += get_process_delta_time()
	
	# 添加新角色（异步加载）
	ResourceLoader.load_threaded_request(character_scenes[character_name].resource_path)
	var new_char = await ResourceLoader.load_threaded_get(character_scenes[character_name].resource_path).instantiate()
	# 设置基础缩放
	new_char.scale = Vector2(0.1, 0.1)
	target_node.add_child(new_char)
	play_enter_animation(new_char)
	is_switching = false

# 角色进场动画
func play_enter_animation(char_node: Node):
	char_node.position = MOVE_OFFSET
	var tween = create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(char_node, "position", Vector2.ZERO, SWITCH_DURATION)
	var anim_player = char_node.get_node("AnimationPlayer")
	anim_player.stop()
	anim_player.play("Enter")

# 角色退场动画
func play_exit_animation(char_node: Node):
	var tween = create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(char_node, "position", -MOVE_OFFSET, SWITCH_DURATION)
	var anim_player = char_node.get_node("AnimationPlayer")
	anim_player.stop()
	anim_player.play("Leave")

# 原地踏步动画
func play_idle_animation(char_node: Node):
	var anim_player = char_node.get_node("AnimationPlayer")
	anim_player.stop()
	anim_player.play("Idle")

# 检查双方确认
func check_player_confirm():
	if p1_ready and p2_ready:
		PlayerManager.selected_characters = current_characters.duplicate(true)
		transition_to_game()

func safe_remove(node: Node):
	if node.is_inside_tree():
		node.get_parent().remove_child(node)
	node.queue_free()

# 场景过渡
func transition_to_game():
	get_tree().change_scene_to_packed(GamePath)

# 功能区
## 显示退出游戏确认窗口
func show_quit_menu() -> void:
	var quit_menu = QuitMenuPath.instantiate()
	bg.add_child(quit_menu)

# 信号接收区
func _process(_delta):
	if InputEvent:
		handle_player_input(1)
		handle_player_input(2)
		check_player_confirm()

## 处理玩家输入
func handle_player_input(player_id: int):
	var prefix = "_P%d" % player_id
	var current_index = p1_current_index if player_id == 1 else p2_current_index
	var is_ready = p1_ready if player_id == 1 else p2_ready
	
	if is_ready: return
	
	# 切换角色
	if Input.is_action_just_pressed("RunLeft" + prefix):
		current_index = wrapi(current_index - 1, 0, characters.size())
	elif Input.is_action_just_pressed("RunRight" + prefix):
		current_index = wrapi(current_index + 1, 0, characters.size())
	
	# 更新显示
	if player_id == 1:
		p1_current_index = current_index
		current_characters[1] = characters[p1_current_index]
		update_character_display(p1_character, current_characters[1])
	else:
		p2_current_index = current_index
		current_characters[2] = characters[p2_current_index]
		update_character_display(p2_character, current_characters[2])
	
	# 确认选择
	if Input.is_action_just_pressed("CloseAttack" + prefix):
		if player_id == 1:
			p1_ready = true
			p_1_label.text = "选择完成"
			p_1_label.add_theme_color_override("font_color", "#5DADEC")
			animation_player.play("P1Choosed")
		else:
			p2_ready = true
			p_2_label.text = "选择完成"
			p_2_label.add_theme_color_override("font_color", "#A40B24")
			animation_player.play("P2Choosed")
		play_idle_animation(p1_character.get_child(0) if player_id ==1 else p2_character.get_child(0))

## 退出游戏按钮
func _on_quit_pressed() -> void:
	show_quit_menu()

func _on_systom_pressed() -> void:
	get_tree().change_scene_to_packed(SettingMenuPath)

func _on_go_home_pressed() -> void:
	get_tree().change_scene_to_file(MainMenuPath)
