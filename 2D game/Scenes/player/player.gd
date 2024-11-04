extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var bullet_scene = preload("res://Scenes/player/player bullet.tscn")  # Preload your player bullet scene
@onready var shield = $Shield
@onready var explosion_anim = $Explosion
@onready var sfx_thrust: AudioStreamPlayer2D = $sfxThrust
@onready var sfx_idle: AudioStreamPlayer2D = $sfxIdle
@onready var sfx_shoot: AudioStreamPlayer2D = $sfxShoot
@onready var sfx_stop_shoot: AudioStreamPlayer2D = $sfxStopShoot
@onready var sfx_explosion: AudioStreamPlayer2D = $sfxExplosion
@onready var sfx_shield: AudioStreamPlayer2D = $sfxShield

@export var speed: float = 200.0
@export var max_lives: int = 3
@export var shoot_cooldown: float = 0.2  # Time between shots

var lives: int = max_lives
var is_invincible: bool = false
var can_shoot: bool = true

func _ready() -> void:
	shield.visible = false  # Hide the shield at the start of the game

func _process(_delta: float) -> void:
	handle_movement()  # Call handle_movement without passing delta
	handle_shooting()  # Handle shooting logic

# Separate function to handle player movement
func handle_movement() -> void:
	var direction: Vector2 = Vector2.ZERO
	var current_speed = speed
	if lives > 0:
		if Input.is_action_pressed("focus"):
			current_speed /= 2

		# Move Up
		if Input.is_action_pressed("up"):
			direction.y -= 1
			if anim.animation != "thrustForward":
				anim.play("thrustForward")
			if not sfx_thrust.playing:
				sfx_thrust.play()  # Play thrust sound if not already playing
		# Move Down
		elif Input.is_action_pressed("down"):
			direction.y += 1
			if anim.animation != "thrustBackward":
				anim.play("thrustBackward")

		# Move Left
		if Input.is_action_pressed("left"):
			direction.x -= 1
			if Input.is_action_pressed("up"):
				if anim.animation != "thrustLeft":
					anim.play("thrustLeft")
				if not sfx_thrust.playing:
					sfx_thrust.play()
			elif anim.animation != "turnLeft":
				anim.play("turnLeft")

		# Move Right
		elif Input.is_action_pressed("right"):
			direction.x += 1
			if Input.is_action_pressed("up"):
				if anim.animation != "thrustRight":
					anim.play("thrustRight")
				if not sfx_thrust.playing:
					sfx_thrust.play()
			elif anim.animation != "turnRight":
				anim.play("turnRight")

		# Stop thrust sound if no "thrust" animation is playing
		if not Input.is_action_pressed("up") and not Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
			if sfx_thrust.playing:
				sfx_thrust.stop()

		# Play sfx_idle if any movement key is pressed and the sound is not already playing
		if direction != Vector2.ZERO and not sfx_idle.playing:
			sfx_idle.play()
		# Stop sfx_idle if no movement keys are pressed
		elif direction == Vector2.ZERO and sfx_idle.playing:
			sfx_idle.stop()

		# Normalize direction to prevent faster diagonal movement
		if direction.length() > 0:
			direction = direction.normalized()
			velocity = direction * current_speed
			move_and_slide()
		else:
			if anim.animation != "idle":
				anim.play("idle")

# Function to handle shooting
func handle_shooting() -> void:
	if lives > 0 and Input.is_action_pressed("shoot") and can_shoot:
		shoot_bullet()
		if not sfx_shoot.playing:
			sfx_shoot.play()
	elif not Input.is_action_pressed("shoot") and sfx_shoot.playing:
		sfx_shoot.stop()

# Function to shoot bullets
func shoot_bullet() -> void:
	can_shoot = false  # Prevent shooting again immediately
	var bullet = bullet_scene.instantiate()  # Create a new bullet instance
	
	# Set bullet position to slightly below the player's position
	bullet.position = position + Vector2(0, -80)  # Adjust the Y offset as needed
	bullet.direction = Vector2.UP  # Set the direction of the bullet to shoot upwards
	get_tree().current_scene.add_child(bullet)  # Add bullet to the scene

	# Start a cooldown timer
	await get_tree().create_timer(shoot_cooldown).timeout  # Change yield to await
	can_shoot = true  # Allow shooting again after cooldown

# Handle input release for stop animation
func _input(event: InputEvent) -> void:
	if event.is_action_released("up") or event.is_action_released("down") or event.is_action_released("left") or event.is_action_released("right"):
		if anim.animation != "stop":
			anim.play("stop")
	
	# Play stop shoot sound when the shoot button is released
	if event.is_action_released("shoot"):
		sfx_stop_shoot.play()

# Function to handle player getting hit
func take_damage():
	if is_invincible:
		return
	lives -= 1
	if lives > 0:
		activate_invincibility()
	else:
		play_explosion()
		get_node("../GameOver").game_over()

# Function to activate invincibility frames and shield
func activate_invincibility() -> void:
	is_invincible = true
	shield.visible = true
	shield.modulate.a = 0.5
	sfx_shield.play()
	await get_tree().create_timer(3.0).timeout  # Change yield to await
	shield.visible = false
	shield.modulate.a = 1.0
	is_invincible = false 

# Function to play explosion animation and remove player
func play_explosion() -> void:
	reset()
	anim.visible = false
	explosion_anim.visible = true
	explosion_anim.play("explode")
	sfx_explosion.play()  # Play explosion sound
	await explosion_anim.animation_finished  # Change yield to await
	queue_free()

func reset() -> void:
	lives = max_lives
	visible = true
	anim.visible = true
	MainScene.score = 0
