extends Control

@export var confirm_sound:AudioStream
@export var move_sound:AudioStream

@onready var title: Label = $BG/Title

const MainMenuPath:String = "res://scenes/MainMenu/MainMenu.tscn"
const GamePath:String = "res://scenes/Game/Game.tscn"

var loser: Player
var player_P1: Player
var player_P2: Player

func set_result(player_id, player1, player2):
	loser = player_id
	player_P1 = player1
	player_P2 = player2

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_title()
	_burn_animation()

func _burn_animation() -> void:
	var tween:Tween = create_tween()
	

func set_title():
	if loser == player_P1:
		title.text = "恭喜红方获胜"
	else:
		title.text = "恭喜蓝方获胜"

func _on_comfirm_pressed() -> void:
	AudioManager.play_sfx(confirm_sound)
	#var mainmenu_scene:PackedScene = ResourceLoader.load(MainMenuPath)
	#var mainmenu_page = mainmenu_scene.instantiate()

func _on_quit_pressed() -> void:
	AudioManager.play_sfx(confirm_sound)
	get_tree().reload_current_scene()

func _on_comfirm_focus_entered() -> void:
	AudioManager.play_sfx(move_sound)

func _on_quit_focus_entered() -> void:
	AudioManager.play_sfx(move_sound)

	#var status = ResourceLoader.load_threaded_get_status(target_scene_path)
#
	#match status:
		#ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			#var progress_array = []
			#ResourceLoader.load_threaded_get_progress(target_scene_path, progress_array)
			#if not progress_array.is_empty():
				#load_progress = progress_array[0]
				#progress_bar.value = load_progress * 100 # 进度条通常是0-100
				#loading_label.text = "加载中... %d%%" % int(progress_bar.value)
			#else:
				## 有时候 progress_array 可能为空，或者进度更新不那么频繁
				## 可以显示一个旋转的图标或者简单的“加载中...”
				#loading_label.text = "加载中..."
#
		#ResourceLoader.THREAD_LOAD_LOADED:
			## 资源已加载完成，获取资源实例并切换场景
			#var loaded_scene_packed = ResourceLoader.load_threaded_get(target_scene_path)
			#if loaded_scene_packed:
				#get_tree().change_scene_to_packed(loaded_scene_packed)
			#else:
				#print("无法获取加载的场景！")
				#loading_label.text = "加载失败！"
#
			#set_process(false) # 停止 _process 函数，因为加载已完成
#
		#ResourceLoader.THREAD_LOAD_FAILED:
			#print("异步加载失败！")
			#loading_label.text = "加载失败！"
			#set_process(false)
