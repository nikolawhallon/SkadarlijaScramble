extends Node2D

func _ready():
	pass

func _process(delta):
	pass

func _on_player_item_picked_up(item):
	if item == "violin":
		$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureRect.texture = load("res://Assets/UI/violin_icon.png")
	elif item == "tamburica":
		$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureRect.texture = load("res://Assets/UI/tamburica_icon.png")
