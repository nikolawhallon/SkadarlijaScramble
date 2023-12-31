extends CharacterBody2D

signal item_picked_up(item)
signal performing(action)

const SPEED = 100.0

# TODO: try to properly use enums
# it offers no benefit to be mixing strings and enums
enum Item {VIOLIN, TAMBURICA}
var item_held = null

func _ready():
	$AnimatedSprite2D.play("idle_down")

func external_pickup(kind):
	if kind == "tamburica":
		item_held = Item.TAMBURICA
		item_picked_up.emit("tamburica")

func _physics_process(delta):
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
