extends Node2D

var happiness = 50.0
var game_over = false
var score = 0

func _ready():
	$YSort/Tamburica/PickUpBubble.player = $YSort/Player
	$YSort/Violin/PickUpBubble.player = $YSort/Player
	$YSort/EspressoMachine/PickUpBubble.player = $YSort/Player
	$YSort/Food/PickUpBubble.player = $YSort/Player
	
func _process(delta):
	if game_over and Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		return
		
	# TODO: due to the size of the texture, "0" is actually below the meter
	if not game_over:
		if happiness == 0 and $GameOverTimer.is_stopped():
			$GameOverTimer.start()
		if not $GameOverTimer.is_stopped():
			$CanvasLayer/Control/MarginContainer/HBoxContainer/CountDown.visible = true
			$CanvasLayer/Control/MarginContainer/HBoxContainer/CountDown.text = str(int($GameOverTimer.time_left))
	
	# another hack
	$YSort/Player.can_serve_coffee_or_food = false
	var npcs = get_tree().get_nodes_in_group("NPC")
	for npc in npcs:
		if npc.desire == "coffee" and npc.global_position.distance_to($YSort/Player.global_position) < 25 and $YSort/Player.item_held == $YSort/Player.Item.COFFEE:
			$YSort/Player.can_serve_coffee_or_food = true
		if npc.desire == "food" and npc.global_position.distance_to($YSort/Player.global_position) < 25 and $YSort/Player.item_held == $YSort/Player.Item.FOOD:
			$YSort/Player.can_serve_coffee_or_food = true		

func _on_player_item_picked_up(item):
	if item == "violin":
		$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureRect.texture = load("res://Assets/UI/violin_icon.png")
	elif item == "tamburica":
		$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureRect.texture = load("res://Assets/UI/tamburica_icon.png")
	elif item == "coffee":
		$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureRect.texture = load("res://Assets/UI/coffee_icon.png")
	elif item == "food":
		$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureRect.texture = load("res://Assets/UI/food_icon.png")
	else:
		$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureRect.texture = load("res://Assets/UI/empty_icon.png")

func _on_player_performing(action):
	# broadcast this action to all NPCs
	var npcs = get_tree().get_nodes_in_group("NPC")
	
	for npc in npcs:
		npc.notify_player_performing(action, $YSort/Player.global_position)

func _on_npc_happiness_changed(amount):
	happiness = clamp(happiness + amount, 0, 100)
	$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureProgressBar.value = happiness

func _on_game_over_timer_timeout():
	$CanvasLayer/Control/MarginContainer/HBoxContainer/CountDown.visible = false
	$YSort/Player._game_over()
	$CanvasLayer/Control/GameOverContainer.visible = true
	game_over = true

func _on_score_timer_timeout():
	if game_over:
		return
	score += 1
	$CanvasLayer/Control/MarginContainerTop/HBoxContainer/ScoreValue.text = str(score)
