# AdaptiveCamera.gd
extends Camera2D

@onready var fight: TileMapLayer = $"../Fight"


@export var min_zoom := 0.35   # 最小缩放
@export var max_zoom := 1.3   # 最大缩放
@export var edge_padding := 750.0  # 视野边缘留白
@export var smooth_speed := 8.0    # 移动平滑度

var map_rect := Rect2()   # 地图边界
var players: Array


func _ready():
	# 初始化地图边界（根据实际地图数据调整）
	update_map_bounds()
	zoom = Vector2(min_zoom, min_zoom)
	reset_smoothing()


func _process(delta):
	if players.size() == 0:
		return

	# 计算包围盒
	var bounds = calculate_bounds(players)
	var target_position = bounds.position + bounds.size / 2
	var target_zoom = calculate_zoom(bounds.size)
	target_position = target_position.clamp(map_rect.position, map_rect.end)

	# 平滑过渡
	position = lerp(position, target_position, smooth_speed * delta)
	zoom = lerp(zoom, target_zoom, smooth_speed * delta)

	# 震动模拟
	if PlayerManager.shake_intensity > 0:
		offset = Vector2(
			randf_range(-PlayerManager.shake_intensity, PlayerManager.shake_intensity),
			randf_range(-PlayerManager.shake_intensity, PlayerManager.shake_intensity))
		PlayerManager.shake_intensity = lerp(PlayerManager.shake_intensity, 0.0, 5.0 * delta)


func calculate_bounds(players: Array) -> Rect2:
	var min_pos := Vector2.INF
	var max_pos := -Vector2.INF

	for player in players:
		var global_pos_min = player.global_position - Vector2(52,130)  # 使用全局坐标
		var global_pos_max = player.global_position + Vector2(52,130)  # 使用全局坐标
		min_pos = min_pos.min(global_pos_min)
		max_pos = max_pos.max(global_pos_max)

	return Rect2(min_pos, max_pos - min_pos).grow(edge_padding * GlobalSetting.scale_factor)


func calculate_zoom(size: Vector2) -> Vector2:
	var window_size := get_tree().get_root().get_window().size
	# 直接使用扩展后的尺寸计算
	var zoom_x := window_size.x / size.x
	var zoom_y := window_size.y / size.y
	var target_zoom = clampf(min(zoom_x, zoom_y), min_zoom, max_zoom)
	return Vector2(target_zoom, target_zoom)


func update_map_bounds():
	var tilemap = fight
	var used = tilemap.get_used_rect()

	# 转换到全局坐标
	var global_start = tilemap.to_global(tilemap.map_to_local(used.position))
	var global_end = tilemap.to_global(tilemap.map_to_local(used.end))
	map_rect = Rect2(global_start, global_end - global_start)

	limit_left = map_rect.position.x
	limit_right = map_rect.end.x
	limit_top = map_rect.position.y
	limit_bottom = map_rect.end.y


func update_players(all_players: Array):
	players = all_players
