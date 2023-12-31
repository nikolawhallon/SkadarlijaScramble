extends Node2D

var happiness = 50.0

func _ready():
	$YSort/Tamburica/PickUpBubble.player = $YSort/Player
	$YSort/Violin/PickUpBubble.player = $YSort/Player
	$YSort/EspressoMachine/PickUpBubble.player = $YSort/Player
	$YSort/Food/PickUpBubble.player = $YSort/Player
	
func _process(delta):
	pass
	
func _on_player_item_picked_up(item):
	if item == "violin":
		$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureRect.texture = load("res://Assets/UI/violin_icon.png")
	elif item == "tamburica":
		$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureRect.texture = load("res://Assets/UI/tamburica_icon.png")
	elif item == "coffee":
		$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureRect.texture = load("res://Assets/UI/coffee_icon.png")
	elif item == "food":
		$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureRect.texture = load("res://Assets/UI/food_icon.png")

func _on_player_performing(action):
	# broadcast this action to all NPCs
	var npcs = get_tree().get_nodes_in_group("NPC")
	
	for npc in npcs:
		npc.notify_player_performing(action, $YSort/Player.global_position)

func _on_npc_happiness_changed(amount):
	happiness = clamp(happiness + amount, 0, 100)
	$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureProgressBar.value = happiness
