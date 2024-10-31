extends CharacterBody2D

@export var health: int = 1  # Enemy health, adjustable in the editor
@onready var explosion_anim = $Explosion
@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("Enemies")
	anim.visible = true
	explosion_anim.visible = false  # Hide explosion initially

func _on_bullet_body_entered(body: Node) -> void:
	if body.is_in_group("PlayerBullets"):
		health -= 1  # Reduce enemy health by 1
		body.queue_free()  # Remove the bullet upon collision
		
		if health <= 0:
			die()  # Trigger death sequence if health is depleted

func die() -> void:
	anim.visible = false
	explosion_anim.visible = true
	explosion_anim.play("explode")

	if get_tree().root.has_node("score"):
		var score_node = get_tree().root.get_node("score")
		score_node.value += 1
	await explosion_anim.animation_finished
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("PlayerBullets"):
		_on_bullet_body_entered(body)
