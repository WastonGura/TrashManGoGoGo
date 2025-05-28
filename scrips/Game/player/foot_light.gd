extends Sprite2D

@export var player: Player

@export var blue_foot_light: CompressedTexture2D
@export var red_foot_light: CompressedTexture2D

func _ready() -> void:
	var player_id = player.player_id
	if player_id == 1:
		self.texture = blue_foot_light
	elif player_id == 2:
		self.texture = red_foot_light
