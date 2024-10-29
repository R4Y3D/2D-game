extends Area2D

@export var speed: float = 800.0  # Speed of the bullet

var direction: Vector2

func _ready() -> void:
	# Set a timer to delete the bullet after a certain duration
	await get_tree().create_timer(5.0).timeout  # Bullet exists for 20 seconds
	queue_free()

func _process(delta: float) -> void:
	position += direction * speed * delta  # Move the bullet

func _on_Area2D_body_entered(body):
	# Check if the body that entered is a player
	if body.is_in_group("player"):
		body.take_damage()  # Call take_damage method on the player
		queue_free()  # Remove the bulleta
