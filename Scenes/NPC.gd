extends StaticBody2D

signal happiness_changed(amount)

var rng = RandomNumberGenerator.new()
var desire = null

func _ready():
	print("Starting Timer")
	$Timer.start()

func _process(delta):
	happiness_changed.emit(-0.01)

func _on_timer_timeout():
	print("Timer timed out")
	var random_number = rng.randf()
	if random_number < 0.33:
		desire = "music"
	elif random_number < 0.66:
		desire = "coffee"
	else:
		desire = "food"
	print(desire)
	# this isn't the right condition, I'm just testing
	$Timer.start()

# I could have the Game relay signals from the Player to all NPCs
# including the following information:
# - action being performed
# - coordinates of the Player
# then, this script could do a quick check to see if this NPCs
# desire is being met, increase some happiness counter,
# signal that to Game, and if the happiness counter reaches a certain point,
# nullify the desire and restart the Timer for a new desire
