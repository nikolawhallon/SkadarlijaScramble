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
	# broadcast this action to all NPCs
	var npcs = get_tree().get_nodes_in_group("NPC")
	
	for npc in npcs:
		npc.notify_player_performing(action, $YSort/Player.position)

func _on_npc_happiness_changed(amount):
	happiness = clamp(happiness + amount, 0, 100)
	$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureProgressBar.value = happiness
