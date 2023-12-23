extends CharacterBody2D

const SPEED = 100.0

func _ready():
	$AnimatedSprite2D.play("idle_down")

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var x_direction = Input.get_axis("ui_left", "ui_right")
	if x_direction:
		velocity.x = x_direction * SPEED
	else:
		velocity.x = 0

	var y_direction = Input.get_axis("ui_up", "ui_down")
	if y_direction:
		velocity.y = y_direction * SPEED
	else:
		velocity.y = 0
		
	move_and_slide()
