extends Sprite2D

@export var kind = "tamburica"
var player = null

func _ready():
	if kind == "tamburica":
		texture = load("res://Assets/UI/pick_up_tamburica_gamepad.png")
	elif kind == "violin":
		texture = load("res://Assets/UI/pick_up_violin_gamepad.png")
	elif kind == "coffee":
		texture = load("res://Assets/UI/pick_up_coffee_gamepad.png")
	elif kind == "food":
		texture = load("res://Assets/UI/pick_up_food_gamepad.png")
	visible = false
	
func _process(_delta):
	if player == null:
		return
	
	if kind == "tamburica":
		if global_position.distance_to(player.global_position) < 70.0 and player.item_held != player.Item.TAMBURICA:
			visible = true
		else:
			visible = false
	if kind == "violin":
		if global_position.distance_to(player.global_position) < 70.0 and player.item_held != player.Item.VIOLIN:
			visible = true
		else:
			visible = false
	elif kind == "coffee":
		if global_position.distance_to(player.global_position) < 70.0 and player.item_held != player.Item.COFFEE:
			visible = true
		else:
			visible = false
	elif kind == "food":
		if global_position.distance_to(player.global_position) < 70.0 and player.item_held != player.Item.FOOD:
			visible = true
		else:
			visible = false
						
	if visible and not player.item_just_picked_up and Input.is_action_just_pressed("pick_up"):
		player.external_pickup(kind)
