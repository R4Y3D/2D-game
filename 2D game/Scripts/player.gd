extends CharacterBody2D
@onready var anim = $AnimatedSprite2D
# Player movement speed
@export var speed: float = 200.0

func _process(_delta: float) -> void:
	# Reset velocity to zero
	var direction: Vector2 = Vector2.ZERO

	# Handle input for movement
	if Input.is_action_pressed("up"):
		direction.y -= 1
		anim.play("thrustForward")
	if Input.is_action_pressed("down"):
		direction.y += 1
		anim.play("thrustBackward")
	if Input.is_action_pressed("left"):
		direction.x -= 1
		anim.play("turnLeft")
	if Input.is_action_pressed("right"):
		direction.x += 1
		anim.play("turnRight")

	# Normalize direction to prevent faster diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()

	# Apply movement using move_and_slide
	velocity = direction * speed
	move_and_slide()
