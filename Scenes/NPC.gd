extends StaticBody2D

# note that while I've extracted the NPC behavior nicely here,
# the NPC objects still share so much in common, I ought to do more extraction
# they only differ in their location, their sprites/animations, and potentially their collision shapes
# (this is why I have made them all unique StaticBody2Ds in the first place, of course)

signal happiness_changed(amount)

@export var can_desire_coffee = true
@export var can_desire_food = true
@export var can_desire_music = true

var rng = RandomNumberGenerator.new()
var desire = null
var desire_bubble = null
var timeout_time = 10

var default_happiness_decrement = 0.001
var happiness_decrement = default_happiness_decrement
var happiness_increment = 0.1
var max_happiness_for_desire = 10.0
var happiness_for_desire = 0.0

# last hack
var player = null

func _ready():
	$Timer.start()

func _process(delta):
	if desire != null:
		happiness_changed.emit(-happiness_decrement)
		happiness_decrement = clamp(happiness_decrement + default_happiness_decrement * delta / 5.0, default_happiness_decrement, 1.5 * happiness_increment)

		if desire == "coffee" and player.item_held == player.Item.COFFEE and global_position.distance_to(player.global_position) < 25:
			desire_bubble.action_icon_on("coffee")
		elif desire == "food" and player.item_held == player.Item.FOOD and global_position.distance_to(player.global_position) < 25:
			desire_bubble.action_icon_on("food")
		else:
			desire_bubble.action_icon_off()

	if happiness_for_desire >= max_happiness_for_desire:
		desire = null
		$Timer.start(timeout_time)
		if desire_bubble != null:
			desire_bubble.queue_free()
			desire_bubble = null
		happiness_for_desire = 0.0

func _on_timer_timeout():
	if desire_bubble != null:
		desire_bubble.queue_free()
		
	var random_number = rng.randf()
	
	# short-circuit if we decide the NPC will have no desire for an iteration
	if random_number < 0.1:
		desire = null
		desire_bubble = null
		$Timer.start(timeout_time)
		return
	
	random_number = rng.randf()
	desire_bubble = load("res://Scenes/DesireBubble.tscn").instantiate()
	add_child(desire_bubble)

	if random_number < 2.0 / 5.0 and can_desire_music:
		desire = "music"
		desire_bubble.init(-40, "music")
	elif random_number < 3.5 / 5.0 and can_desire_coffee:
		desire = "coffee"
		desire_bubble.init(-40, "coffee")
	elif random_number < 5.0 / 5.0 and can_desire_food:
		desire = "food"
		desire_bubble.init(-40, "food")
	else:
		# hack - I'm not properly doing the fractions above
		# taking into account the actual possible list of desires
		# so if I haven't been able to make a desire bubble by now,
		# let's drop it
		desire_bubble.queue_free()

	#$Timer.start(timeout_time)

func notify_player_performing(action, player_position):
	if desire == "music" and (action == "violin" or action == "tamburica"):
		if global_position.distance_to(player_position) < 100:
			happiness_decrement = default_happiness_decrement
			happiness_changed.emit(happiness_increment)
			happiness_for_desire += happiness_increment
	if desire == "coffee" and action == "coffee":
		if global_position.distance_to(player_position) < 25:
			happiness_decrement = default_happiness_decrement
			happiness_changed.emit(max_happiness_for_desire)
			happiness_for_desire += max_happiness_for_desire
	if desire == "food" and action == "food":
		if global_position.distance_to(player_position) < 25:
			happiness_decrement = default_happiness_decrement
			happiness_changed.emit(max_happiness_for_desire)
			happiness_for_desire += max_happiness_for_desire
