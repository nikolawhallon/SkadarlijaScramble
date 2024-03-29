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
		if not $GameOverTimer.is_stopped() and happiness > 0:
			$GameOverTimer.stop()
			$CanvasLayer/Control/MarginContainerCountDown/CountDown.visible = false
		if not $GameOverTimer.is_stopped():
			$CanvasLayer/Control/MarginContainerCountDown/CountDown.visible = true
			$CanvasLayer/Control/MarginContainerCountDown/CountDown.text = str(int($GameOverTimer.time_left))
	
	# another hack
	$YSort/Player.can_serve_coffee_or_food = false
	var npcs = get_tree().get_nodes_in_group("NPC")
	for npc in npcs:
		if npc.desire == "coffee" and npc.global_position.distance_to($YSort/Player.global_position) < 25 and $YSort/Player.item_held == $YSort/Player.Item.COFFEE:
			$YSort/Player.can_serve_coffee_or_food = true
		if npc.desire == "food" and npc.global_position.distance_to($YSort/Player.global_position) < 25 and $YSort/Player.item_held == $YSort/Player.Item.FOOD:
			$YSort/Player.can_serve_coffee_or_food = true
		npc.player = $YSort/Player

func _on_player_item_picked_up(item):
	if item == "violin":
		$CanvasLayer/Control/MarginContainerItem/TextureRect.texture = load("res://Assets/UI/violin_icon.png")
	elif item == "tamburica":
		$CanvasLayer/Control/MarginContainerItem/TextureRect.texture = load("res://Assets/UI/tamburica_icon.png")
	elif item == "coffee":
		$CanvasLayer/Control/MarginContainerItem/TextureRect.texture = load("res://Assets/UI/coffee_icon.png")
	elif item == "food":
		$CanvasLayer/Control/MarginContainerItem/TextureRect.texture = load("res://Assets/UI/food_icon.png")
	else:
		$CanvasLayer/Control/MarginContainerItem/TextureRect.texture = load("res://Assets/UI/empty_icon.png")

func _on_player_performing(action):
	# broadcast this action to all NPCs
	var npcs = get_tree().get_nodes_in_group("NPC")
	
	for npc in npcs:
		npc.notify_player_performing(action, $YSort/Player.global_position)

func _on_npc_happiness_changed(amount):
	happiness = clamp(happiness + amount, 0, 100)
	$CanvasLayer/Control/MarginContainer/HBoxContainer/TextureProgressBar.value = happiness

func _on_game_over_timer_timeout():
	$CanvasLayer/Control/MarginContainerCountDown/CountDown.visible = false
	$YSort/Player._game_over()
	$CanvasLayer/Control/GameOverContainer.visible = true
	game_over = true

func _on_score_timer_timeout():
	if game_over:
		return
	score += 1
	$CanvasLayer/Control/MarginContainerTop/HBoxContainer/ScoreValue.text = str(score)

"res://Assets/Music/Balkan Bleeps - Retrograd - 06 Pico Pico Piccolina (DMG Mix).ogg"

var song_index = 0
var songs = [
	{ 
		"name": "Pico Pico Piccolina",
		"album": "Retrograd",
		"artist": "Balkan Bleeps",
		"stream": preload("res://Assets/Music/Balkan Bleeps - Retrograd - 06 Pico Pico Piccolina (DMG Mix).ogg")
	},
	{ 
		"name": "Over There",
		"album": "Retrograd",
		"artist": "Balkan Bleeps",
		"stream": preload("res://Assets/Music/Balkan Bleeps - Retrograd - 07 Over There (DMG Mix).ogg")
	},
	{ 
		"name": "Autumn Leaves",
		"album": "Retrograd",
		"artist": "Balkan Bleeps",
		"stream": preload("res://Assets/Music/Balkan Bleeps - Retrograd - 08 Autumn Leaves (DMG Mix).ogg")
	},
	{ 
		"name": "Before Dawn",
		"album": "Retrograd",
		"artist": "Balkan Bleeps",
		"stream": preload("res://Assets/Music/Balkan Bleeps - Retrograd - 09 Before Dawn (DMG Mix).ogg")
	},
	{ 
		"name": "From Vardar to Triglav",
		"album": "Retrograd",
		"artist": "Balkan Bleeps",
		"stream": preload("res://Assets/Music/Balkan Bleeps - Retrograd - 10 From Vardar to Triglav (DMG Mix).ogg")
	},
]

func _on_audio_stream_player_finished():
	if song_index + 1 >= songs.size():
		song_index = 0
	else:
		song_index += 1
	$AudioStreamPlayer.stream = songs[song_index]["stream"]
	$AudioStreamPlayer.play()
