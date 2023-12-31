extends Sprite2D

@export var kind = "tamburica"
var player = null

func _ready():
	if kind == "tamburica":
		texture = load("res://Assets/UI/pick_up_tamburica.png")

	visible = false
	
func _process(_delta):
	if player == null:
		return
	
	if kind == "tamburica":
		if global_position.distance_to(player.global_position) < 70.0 and player.item_held != player.Item.TAMBURICA:
			visible = true
		else:
			visible = false

	if visible and Input.is_action_just_pressed("pick_up"):
		player.external_pickup(kind)
