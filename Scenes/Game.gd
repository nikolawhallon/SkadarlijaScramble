extends Node2D

var happiness = 50.0

func _ready():
	pass

func _process(delta):
	pass
	
func _on_player_item_picked_up(item):
	if item == "violin":
		$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureRect.texture = load("res://Assets/UI/violin_icon.png")
	elif item == "tamburica":
		$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureRect.texture = load("res://Assets/UI/tamburica_icon.png")

func _on_player_performing(action):
	if action == "violin":
		happiness = clamp(happiness + 0.1, 0, 100)
	elif action == "tamburica":
		happiness = clamp(happiness + 0.1, 0, 100)

	$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureProgressBar.value = happiness

func _on_npc_happiness_changed(amount):
	happiness = clamp(happiness + amount, 0, 100)
	$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureProgressBar.value = happiness
