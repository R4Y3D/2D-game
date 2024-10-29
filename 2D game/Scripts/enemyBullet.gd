extends Area2D

@export var speed: float = 400.0  # Bullet speed
var direction: Vector2

func _ready() -> void:
	# Set the bullet's position independent of its parent
	set_as_top_level(true)
	# Ensure the bullet is moving in the correct direction
	direction = Vector2.RIGHT  # Modify based on your shooting logic

func _process(delta: float) -> void:
	position += direction * speed * delta  # Move the bullet

func _on_Bullet_body_entered(body: Node) -> void:
	if body.is_in_group("player"):  # Check if it hits the player
		body.take_damage()  # Call the take_damage function from the player's script
		queue_free()  # Destroy the bullet
	elif body.is_in_group("walls"):  # Check if it hits a wall
		queue_free()  # Destroy the bullet when it hits a wall

# Optional: Timer to destroy bullet after a set time (to avoid bullets existing indefinitely)
func _on_Timer_timeout() -> void:
	queue_free()  # Remove the bullet after a certain time
