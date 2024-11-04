extends CharacterBody2D

@export var health: int = 3  # Enemy health, adjustable in the editor
@onready var explosion_anim = $Explosion
@onready var anim = $AnimatedSprite2D
@onready var sfx_explosion: AudioStreamPlayer2D = $sfxExplosion

# Declare delete_timer as a class variable
var delete_timer: Timer
var is_dead: bool = false  # Flag to ensure die() is only called once

func _ready() -> void:
	add_to_group("Enemies")
	anim.visible = true
	explosion_anim.visible = false  # Hide explosion initially
	self.visible = false  # Start hidden

	# Create a timer to handle delayed appearance
	var start_timer = Timer.new()
	start_timer.wait_time = 10  # Delay appearance by 10 seconds
	start_timer.one_shot = true
	start_timer.connect("timeout", Callable(self, "_on_start_timer_timeout"))
	add_child(start_timer)
	start_timer.start()

	# Initialize the delete timer and add it to the scene
	delete_timer = Timer.new()
	delete_timer.wait_time = 15  # Set for 15 seconds after becoming visible
	delete_timer.one_shot = true
	delete_timer.connect("timeout", Callable(self, "queue_free"))
	add_child(delete_timer)

func _on_start_timer_timeout() -> void:
	# Make the node visible after the start timer times out
	self.visible = true

	# Start the delete timer after becoming visible
	delete_timer.start()

func _on_bullet_body_entered(body: Node) -> void:
	if body.is_in_group("PlayerBullets"):
		health -= 1  # Reduce enemy health by 1
		body.queue_free()  # Remove the bullet upon collision
		
		if health <= 0 and not is_dead:  # Check if health is zero and the enemy is not already dead
			die()  # Trigger death sequence if health is depleted

func die() -> void:
	is_dead = true  # Mark as dead to prevent repeated execution
	anim.visible = false
	explosion_anim.visible = true
	explosion_anim.play("explode")
	sfx_explosion.play()
	
	# Increase score in the main scene
	MainScene.score += 2  # Assuming MainScene is the autoload name
	print(MainScene.score)

	await explosion_anim.animation_finished
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("PlayerBullets"):
		_on_bullet_body_entered(body)
