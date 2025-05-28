class_name EPComponent extends Node2D

@export var EP = 20

func get_EP():
	return EP

func set_EP(new_EP):
	EP = new_EP

func update_ep_by_trash():
	var currernt_ep = get_EP()
	var new_ep = currernt_ep + 20
	set_EP(new_ep)

func consume_EP(amount):
	var new_EP = get_EP() - amount
	new_EP = max(new_EP, 0)
	set_EP(new_EP)
