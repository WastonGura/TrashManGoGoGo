extends CanvasLayer

@export var P1_HPBAR:TextureProgressBar
@export var P1_EPBAR:TextureProgressBar
@export var P2_HPBAR:TextureProgressBar
@export var P2_EPBAR:TextureProgressBar
@export var Title: Label
@export var Years: Label
@export var TrashContainer: Node2D

func _ready() -> void:
	TrashContainer.connect("trash_body_entered", Callable(self, "update_title"))

func update_title(body):
	if body.trash_id == "plastic":
		Title.text = "塑料瓶"
		Years.text = "100年 - 500年"
	elif body.trash_id == "glass":
		Title.text = "玻璃瓶"
		Years.text = "4000年 - 100w年"
	elif body.trash_id == "paper":
		Title.text = "纸"
		Years.text = "1年 - 10年"
	elif body.trash_id == "metal":
		Title.text = "罐头"
		Years.text = "50年 - 100年"
	elif body.trash_id == "drink_can":
		Title.text = "易拉罐"
		Years.text = "80年 - 200年"

func set_player_hp(hp, player_id):
	if player_id == 1:
		P1_HPBAR.value = hp
	elif player_id == 2:
		P2_HPBAR.value = hp

func set_player_ep(ep, player_id):
	if player_id == 1:
		P1_EPBAR.value = ep
	elif player_id == 2:
		P2_EPBAR.value = ep
