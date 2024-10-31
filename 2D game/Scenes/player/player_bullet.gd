extends Area2D

@export var speed: float = 999.0

var direction: Vector2

func _ready() -> void:
	add_to_group("PlayerBullets")
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	# Ensure it’s the enemy and call `_on_bullet_body_entered`
	if body.is_in_group("Enemies") and body.has_method("_on_bullet_body_entered"):
		body._on_bullet_body_entered(self)  # Pass the bullet itself as the argument
		queue_free()  # Remove the bullet after hit
