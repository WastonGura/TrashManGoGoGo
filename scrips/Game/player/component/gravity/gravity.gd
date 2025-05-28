class_name GravityComponent extends Node2D


signal touch_spike
signal hp_area

## 角色节点
@export var player: Player
## PlayControl
@export var player_control: PlayerControl

func _physics_process(delta):
	# 应用重力
	player.velocity.y += player_control.gravity * delta
	for i in player.get_slide_collision_count():
		var collision = player.get_slide_collision(i)
		handle_spike_collisions(collision)

func handle_spike_collisions(spike_collision: KinematicCollision2D) -> void:
	var collider = spike_collision.get_collider()
	if collider is TileMapLayer:
		var tile_map = collider as TileMapLayer
		var global_collision_point = spike_collision.get_position()
		var local_collision_point = tile_map.to_local(global_collision_point + Vector2(0, 26))
		var map_coords = tile_map.local_to_map(local_collision_point)
		var tile_data = tile_map.get_cell_tile_data(map_coords)
		if tile_data and tile_data.get_custom_data("Attack"):
			emit_signal("touch_spike")
		if tile_data and tile_data.get_custom_data("HP"):
			emit_signal("hp_area")
