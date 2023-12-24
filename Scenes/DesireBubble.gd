extends Sprite2D

var y_equilibrium_position = 0
var y_initial_velocity = 10
const k = 2

func _ready():
	y_equilibrium_position = position.y

func init(y_position_offset, kind):
	position.y += y_position_offset
	y_equilibrium_position = position.y
	
	if kind == "music":
		texture = load("res://Assets/UI/desire_music.png")
	if kind == "coffee":
		texture = load("res://Assets/UI/desire_coffee.png")
	if kind == "food":
		texture = load("res://Assets/UI/desire_food.png")

func _process(delta):
	y_initial_velocity += -k * (position.y - y_equilibrium_position)
	position.y += y_initial_velocity * delta
