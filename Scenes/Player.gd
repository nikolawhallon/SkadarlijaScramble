extends CharacterBody2D

signal item_picked_up(item)
signal performing(action)

const SPEED = 100.0

# TODO: try to properly use enums
# it offers no benefit to be mixing strings and enums
enum Item {VIOLIN, TAMBURICA, COFFEE, FOOD}
var item_held = null

var can_serve_coffee_or_food = false

# a hack
var game_over = false

# a hack
var item_just_picked_up = false

func _ready():
	$AnimatedSprite2D.play("idle_down")

func external_pickup(kind):
	if kind == "tamburica":
		item_held = Item.TAMBURICA
		item_picked_up.emit("tamburica")
	elif kind == "violin":
		item_held = Item.VIOLIN
		item_picked_up.emit("violin")
	elif kind == "coffee":
		item_held = Item.COFFEE
		item_picked_up.emit("coffee")
	elif kind == "food":
		item_held = Item.FOOD
		item_picked_up.emit("food")
	item_just_picked_up = true

func _physics_process(delta):
	if game_over:
		return

	item_just_picked_up = false
	
	if Input.is_action_pressed("perform"):
		if item_held != null:
			if item_held == Item.VIOLIN:
				$AnimatedSprite2D.play("play_violin")
				performing.emit("violin")
				return
			elif item_held == Item.TAMBURICA:
				$AnimatedSprite2D.play("play_tamburica")
				performing.emit("tamburica")
				return
			elif item_held == Item.COFFEE and can_serve_coffee_or_food:
				$AnimatedSprite2D.play("serve")
				performing.emit("coffee")
				return
			elif item_held == Item.FOOD and can_serve_coffee_or_food:
				$AnimatedSprite2D.play("serve")
				performing.emit("food")
				return

	# another quick hack, yuck
	if $AnimatedSprite2D.animation == "serve":
		return
		
	var x_direction = Input.get_axis("move_left", "move_right")
	if x_direction:
		velocity.x = x_direction
	else:
		velocity.x = 0

	var y_direction = Input.get_axis("move_up", "move_down")
	if y_direction:
		velocity.y = y_direction
	else:
		velocity.y = 0
	
	velocity = velocity.normalized()
	
	velocity *= SPEED
	
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.play("idle_down")
	else:
		$AnimatedSprite2D.play("walk_down")

	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	
	move_and_slide()

func _game_over():
	game_over = true
	$AnimatedSprite2D.play("idle_down")

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "serve":
		item_held = null
		item_picked_up.emit("")
		# another quick hack, yuck
		$AnimatedSprite2D.play("idle_down")
