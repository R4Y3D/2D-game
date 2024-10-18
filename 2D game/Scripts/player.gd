extends CharacterBody2D
@onready var anim = $AnimatedSprite2D
# Player movement speed
@export var speed: float = 200.0

func _process(_delta: float) -> void:
	# Reset velocity to zero
	var direction: Vector2 = Vector2.ZERO
	var current_speed = speed

	# Check if the focus button is held, halve the speed
	if Input.is_action_pressed("focus"):
		current_speed /= 2

	# Handle input for movement
	var is_up_pressed = Input.is_action_pressed("up")
	var is_down_pressed = Input.is_action_pressed("down")
	var is_left_pressed = Input.is_action_pressed("left")
	var is_right_pressed = Input.is_action_pressed("right")

	# Diagonal movement (up and left or up and right)
	if is_up_pressed and is_left_pressed:
		direction.y -= 1
		direction.x -= 1
		if anim.animation != "thrustLeft":
			anim.play("thrustLeft")
	elif is_up_pressed and is_right_pressed:
		direction.y -= 1
		direction.x += 1
		if anim.animation != "thrustRight":
			anim.play("thrustRight")
	else:
		# Handle normal input for movement
		if is_up_pressed:
			direction.y -= 1
			if anim.animation != "thrustForward":
				anim.play("thrustForward")
		elif is_down_pressed:
			direction.y += 1
			if anim.animation != "thrustBackward":
				anim.play("thrustBackward")

		if is_left_pressed:
			direction.x -= 1
			if anim.animation != "turnLeft":
				anim.play("turnLeft")
		elif is_right_pressed:
			direction.x += 1
			if anim.animation != "turnRight":
				anim.play("turnRight")

	# Normalize direction to prevent faster diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()
	else:
		# Play idle animation when no input is pressed
		if anim.animation != "idle":
			anim.play("idle")

	# Apply movement using move_and_slide with the current speed (halved if focus is held)
	velocity = direction * current_speed
	move_and_slide()

# Handle input release for stop animation
func _input(event: InputEvent) -> void:
	if event.is_action_released("up") or event.is_action_released("down") or event.is_action_released("left") or event.is_action_released("right"):
		if anim.animation != "stop":
			anim.play("stop")
